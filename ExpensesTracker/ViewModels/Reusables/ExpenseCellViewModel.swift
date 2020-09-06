//
//  ExpenseCellViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class ExpenseCellViewModel: ObservableObject {
	@Published var expensesRepository = ExpensesRepository.shared
	var expense: Expense
	
	var id: String { expense.id }
	var amount: String { String(format: "%.2f", expense.amount) }
	var timestamp: String { expense.timestamp.dateValue().shortDateTime }
	var category: String { "nil" }
	var store: String { "nil" }
	var location: String { "nil" }
	
	init(expense: Expense) {
		self.expense = expense
	}
	
	#warning("broken")
	func deleteExpense() {
//		expensesRepository.deleteExpense(expense) { error in
//			// TODO: Implement error handling
//		}
	}
}
