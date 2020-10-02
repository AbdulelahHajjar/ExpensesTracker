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
    @Published private var currentBudgetID: String? = nil
    
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
        guard let user = userDataRepository.userData,
              let previousExpense = expenses.first(where: { $0.id == expense.id }),
              var budget = budgetsRepository.budgets.first(where: { $0.id == budgetID }) else {
            completion(FirestoreError.unknown) //Should be something better than this
            return
        }
        
        budget.insights.addToDailySpendings(date: previousExpense.date, amount: -previousExpense.amount)
        budget.insights.addToDailySpendings(date: expense.date, amount: expense.amount)
        
        #warning("Use transaction")
        budgetsRepository.updateBudget(budget) { (error) -> (Void) in
            if error == nil {
                self.firestoreService.saveDocument(collection: .users_budgets_expenses(userID: user.id, budgetID: budgetID), model: expense, completion: completion)
            }
        }
	}
	
	func deleteExpense(expense: Expense, budgetID: String, completion: @escaping (Error?) -> ()) {
		guard let user = userDataRepository.userData,
              var budget = budgetsRepository.budgets.first(where: { $0.id == budgetID }) else { return }
        
        budget.insights.addToDailySpendings(date: expense.date, amount: -expense.amount)
        
        budgetsRepository.updateBudget(budget) { (error) -> (Void) in
            if error == nil {
                self.firestoreService.deleteDocument(collection: .users_budgets_expenses(userID: user.id, budgetID: budgetID), model: expense, completion: completion)
            }
        }
	}
	
	// MARK: - Helpers
	private func loadExpenses(userID: String?, budgetID: String?) {
		guard let userID = userID, let budgetID = budgetID else { return }
		
		firestoreService.getDocuments(collection: .users_budgets_expenses(userID: userID, budgetID: budgetID), attachListener: true) { (result: Result<[Expense], Error>) in
            switch result {
                case .success(let expenses):
                    self.setExpenses(expenses)
                    print("ExpensesRepository: Downloaded \(expenses.count) Expense\(expenses.count == 1 ? "" : "s"), for Budget: \(String(describing: budgetID))")
                case .failure(_):
                    self.setExpenses([])
            }
		}
	}
	
	private func registerSubscribers() {
		budgetsRepository.$dashboardBudget
			.receive(on: DispatchQueue.main)
			.sink {
                if $0?.id != self.currentBudgetID && $0 != nil {
                    self.loadExpenses(userID: self.userDataRepository.userData?.id, budgetID: $0?.id)
                }
                self.currentBudgetID = $0?.id
			}
			.store(in: &cancellables)
	}
    
    // MARK: - Setters
    private func setExpenses(_ expenses: [Expense]) {
        DispatchQueue.main.async { self.expenses = expenses }
    }
}
