//
//  ExpenseCellViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 06/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class ExpenseCellViewModel: ObservableObject, Identifiable {
	@Published private var expensesRepository = ExpensesRepository.shared
	@Published private var budgetsRepository = BudgetsRepository.shared
	
	private(set) var expense: Expense
	
	init(expense: Expense) {
		self.expense = expense
	}
	
	func deleteExpense() {
		guard let budgetID = budgetsRepository.dashboardBudgetID else { return }
		expensesRepository.deleteExpense(expense: expense, budgetID: budgetID) { error in
			// TODO: Implement error handling
		}
	}
}
