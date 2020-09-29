//
//  ExpensesRepository.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class ExpensesRepository: ObservableObject {
	static let shared                         = ExpensesRepository()

	@Published private(set) var expenses      = [Expense]()
	@Published private var firestoreService   = FirestoreService.shared
	@Published private var userDataRepository = UserDataRepository.shared
	@Published private var budgetsRepository = BudgetsRepository.shared
	private var cancellables                  = Set<AnyCancellable>()
	
	private init() { registerSubscribers() }
	deinit { print("Deinit: ExpensesRepository") }
	// MARK: - Expenses CRUD
	func addExpense(expense: Expense, budgetID: String, completion: @escaping (Error?) -> ()) {
		guard let user = userDataRepository.userData else { return }
        
        var x = budgetsRepository.budgets.first { $0.id == budgetID }!
        x.insights.addToDailySpendings(date: expense.date, amount: expense.amount)
        
        budgetsRepository.updateBudget(x) { error in
            if error != nil { return }
            self.firestoreService.saveDocument(collection: .users_budgets_expenses(userID: user.id, budgetID: budgetID), model: expense, completion: completion)
        }
	}
	
	func updateExpense(expense: Expense, budgetID: String, completion: @escaping (Error?) -> ()) {
		addExpense(expense: expense, budgetID: budgetID, completion: completion)
	}
	
	func deleteExpense(expense: Expense, budgetID: String, completion: @escaping (Error?) -> ()) {
		guard let user = userDataRepository.userData else { return }
		firestoreService.deleteDocument(collection: .users_budgets_expenses(userID: user.id, budgetID: budgetID), model: expense, completion: completion)
	}
	
	// MARK: - Helpers
	private func loadExpenses(userID: String?, budgetID: String?) {
		guard let userID = userID, let budgetID = budgetID else { return }
		
		firestoreService.getDocuments(collection: .users_budgets_expenses(userID: userID, budgetID: budgetID), attachListener: true) { (result: Result<[Expense], Error>) in
			DispatchQueue.main.async {
				switch result {
					case .success(let expenses):
                        self.expenses = expenses
                        print("ExpensesRepository: Downloaded \(expenses.count) Expense\(expenses.count == 1 ? "" : "s"), for Budget: \(String(describing: self.budgetsRepository.dashboardBudgetID))")
					case .failure(_):
                        self.expenses = []
				}
			}
		}
	}
	
	private func registerSubscribers() {
		budgetsRepository.$dashboardBudgetID
			.receive(on: DispatchQueue.main)
			.sink {
                if $0 != nil { self.loadExpenses(userID: self.userDataRepository.userData?.id, budgetID: $0)}
			}
			.store(in: &cancellables)
	}
}
