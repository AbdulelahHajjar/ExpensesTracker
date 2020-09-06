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
	private var cancellables                  = Set<AnyCancellable>()
	
	private init() { registerSubscribers() }
	
	// MARK: - Budgets CRUD
	func addBudget(_ budget: Budget, completion: @escaping (Error?) -> (Void)) {
		guard let user = userDataRepository.userData else { return }
		firestoreService.saveDocument(collection: .users_budgets(userID: user.id), model: budget) { error in
			if error == nil {
				self.setDashboardBudgetID(id: budget.id)
			}
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
					self.dashboardBudgetID = self.retrieveDashboardBudgetID()
					print("BudgetsRepository: Downloaded \(budgets.count) Budget\(budgets.count == 1 ? "" : "s")")
				case .failure(_): break
				}
			}
		}
	}
	
	private func registerSubscribers() {
		userDataRepository.$userData
			.receive(on: DispatchQueue.main)
			.sink {
				if $0 != nil { self.loadBudgets() }
			}
			.store(in: &cancellables)
	}
	
	func setDashboardBudgetID(id: String) {
		self.dashboardBudgetID = id
		userDefaultsService.save(key: UserDefaults.Keys.Budgets.dashboardBudgetID.rawValue, value: id)
	}
	
	private func retrieveDashboardBudgetID() -> String? {
		userDefaultsService.retrieve(key: UserDefaults.Keys.Budgets.dashboardBudgetID.rawValue) as? String
	}
}
