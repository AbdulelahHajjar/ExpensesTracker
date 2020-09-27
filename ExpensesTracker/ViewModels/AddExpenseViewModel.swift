//
//  AddExpenseViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase

final class AddExpenseViewModel: ObservableObject {
	@Published private var expensesRepository = ExpensesRepository.shared
	@Published private var budgetsRepository = BudgetsRepository.shared
	
	@Published var amount: String = ""
	@Published var date: Date = Date()
	
	var doubleAmount: Double { Double(amount) ?? -1 }
	
	func addExpense() {
		guard let budgetID = budgetsRepository.dashboardBudgetID else { return }
		let expense = Expense(id: UUID().uuidString, amount: doubleAmount, date: date)
		expensesRepository.addExpense(expense: expense, budgetID: budgetID) { error in
			// TODO: Error handling
		}
	}
}
