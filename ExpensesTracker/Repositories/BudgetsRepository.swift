//
//  BudgetsRepository.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine
import Firebase

final class BudgetsRepository: ObservableObject {
	static let shared                         = BudgetsRepository()
	
    @Published private(set) var budgets       = [Budget]()
    
	@Published private(set) var dashboardBudgetID: String? = nil
	@Published private var firestoreService   = FirestoreService.shared
	@Published private var userDataRepository = UserDataRepository.shared
	@Published private var userDefaultsService = UserDefaultsService.shared
	
	@Published private var budgetTimers = [Timer]()
	
	private var cancellables = Set<AnyCancellable>()
	
	private init() { registerSubscribers() }
	
	// MARK: - Combine
	private func registerSubscribers() {
		userDataRepository.$userData
			.receive(on: DispatchQueue.main)
			.sink {
                if $0 != nil { self.loadBudgets() }
		}
		.store(in: &cancellables)
		
		$budgets
			.receive(on: DispatchQueue.main)
			.debounce(for: 1.0, scheduler: RunLoop.main)
			.map { $0.filter { $0.status != .archived } }
            .sink { self.refreshBudgetTimers(budgets: $0) }
			.store(in: &cancellables)
		
		$budgetTimers
			.sink {
				if !$0.isEmpty {
					print("***B\nTimers Updated! to:")
					let fireDates = $0.map { $0.fireDate.shortDateTime }
					for fireDate in fireDates { print(fireDate) }
					print("***E")
				}
			}
			.store(in: &cancellables)
		
		NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { _ in self.refreshBudgetTimers(budgets: self.budgets) }
			.store(in: &cancellables)
	}
	
	// MARK: - Budgets CRUD
	func addBudget(_ budget: Budget, completion: @escaping (Error?) -> (Void)) {
		guard let user = userDataRepository.userData else { return }
        
		firestoreService.saveDocument(collection: .users_budgets(userID: user.id), model: budget) { error in
			if error == nil {
                self.updateDashboardBudgetID(id: budget.id)
			}
			completion(error)
		}
	}
	
	func updateBudget(_ budget: Budget, completion: @escaping (Error?) -> (Void)) {
		addBudget(budget, completion: completion)
	}
	
	func deleteBudget(_ budget: Budget, completion: @escaping (Error?) -> (Void)) {
		guard let user = userDataRepository.userData else { return }
		firestoreService.deleteDocument(collection: .users_budgets(userID: user.id), model: budget, completion: completion)
	}
    
	// MARK: - Helpers
	private func loadBudgets() {
		guard let userID = userDataRepository.userData?.id else { return }
		
		firestoreService.getDocuments(collection: .users_budgets(userID: userID), attachListener: true) { (result: Result<[Budget], Error>) in
			DispatchQueue.main.async {
				switch result {
				case .success(let budgets):
                    self.budgets = budgets
                    self.setDashboardBudgetID()
					print("BudgetsRepository: Downloaded \(budgets.count) Budget\(budgets.count == 1 ? "" : "s")")
				case .failure(_): break
				}
			}
		}
	}
	
	// MARK: - Helpers
	func updateDashboardBudgetID(id: String) {
        if dashboardBudgetID == id { return }
		dashboardBudgetID = id
		userDefaultsService.save(key: UserDefaults.Keys.Budgets.dashboardBudgetID.rawValue, value: id)
	}
	
	private func setDashboardBudgetID() {
        guard let id = userDefaultsService.retrieve(key: UserDefaults.Keys.Budgets.dashboardBudgetID.rawValue) as? String, budgetExists(with: id) else {
            dashboardBudgetID = nil
            return
        }
        dashboardBudgetID = id
	}
    
    private func budgetExists(with id: String) -> Bool {
        for budget in budgets.filter({ $0.status == .active }) {
            if budget.id == id { return true }
        }
        return false
    }
	
	// MARK: - Timers
	private func refreshBudgetTimers(budgets: [Budget]) {
		clearBudgetTimers()
        
		var budgetTimersCopy = budgetTimers
		
		for budget in budgets {
			let status = budget.status
			guard status != .archived else { continue }
			
			var selector: Selector
			
			if status == .active {
				selector = budget.repeatCycle == .never ? #selector(archiveBudget(sender:)) : #selector(continueCycle(sender:))
			} else {
				selector = #selector(activateBudget(sender:))
			}
			
			let fireDate = status == .active ? budget.endDate : budget.startDate
			
			let timer = Timer(fireAt: fireDate, interval: 0, target: self, selector: selector, userInfo: budget, repeats: false)
			budgetTimersCopy.append(timer)
			RunLoop.main.add(timer, forMode: .common)
		}
		
		budgetTimers = budgetTimersCopy
	}
    
    private func clearBudgetTimers() {
        if !budgetTimers.isEmpty {
            for timer in budgetTimers { timer.invalidate() }
            budgetTimers = []
        }
    }
	
	@objc private func archiveBudget(sender: Timer) {
		guard var budget = sender.userInfo as? Budget else { return }
		print("Archiving Budget \(budget) with Repeat Cycle \(budget.repeatCycle) at \(budget.endDate)")
		budget.archive()
		updateBudget(budget) { error in
			// TODO: Handle
		}
	}
	
	//This is used to activate a scheduled budget created by the user.
	@objc private func activateBudget(sender: Timer) {
		guard var budget = sender.userInfo as? Budget else { return }
		print("Activating Budget \(budget) with Repeat Cycle \(budget.repeatCycle) at \(budget.startDate)")
		budget.activate()
		updateBudget(budget) { error in
			// TODO: Handle
		}
	}
	
	//This is used to archive the current budget, then create a new budget with the same information.
	@objc private func continueCycle(sender: Timer) {
		guard var currentBudget = sender.userInfo as? Budget else { return }
		print("Continuing the cycle for Budget \(currentBudget) with Repeat Cycle \(currentBudget.repeatCycle) at \(currentBudget.endDate)")
		
		//Fix multiple creation of budget if endDate of new budget in before the current date.
		let newBudget = Budget(id: UUID().uuidString,
							   name: currentBudget.name,
							   amount: currentBudget.amount,
							   savingsPercentage: currentBudget.savingsPercentage,
							   repeatCycle: currentBudget.repeatCycle,
							   startDate: currentBudget.endDate)!
		currentBudget.archive()
		updateBudget(currentBudget) { error in
            self.addBudget(newBudget) { error in
				
			}
		}
	}
}
