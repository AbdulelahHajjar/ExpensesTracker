//
//  ExpenseEditorViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 30/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI
import Firebase

final class EditExpenseViewModel: ObservableObject {
	@Published var expensesRepository = ExpensesRepository.shared
	
	var expense: Expense
	
	@Published var amount = ""
	@Published var date = Date()
	
	init(expense: Expense) {
		self.expense = expense
		self.amount = String(expense.amount)
		self.date = expense.timestamp.dateValue()
	}
	
	#warning("broken")
	func updateExpense() {
//		expense.amount = Double(amount) ?? -1
//		expense.timestamp = Timestamp(date: date)
//		expensesRepository.updateExpense(expense) { error in
//			// TODO: Implement error handling
//		}
	}
}
