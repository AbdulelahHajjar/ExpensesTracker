//
//  ExpenseCellViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class ExpenseCellViewModel: ObservableObject {
	var expense: Expense
	
	var amount: String { "\(expense.amount)" }
	var timestamp: String { expense.timestamp.dateValue().shortDateTime }
	var category: String { "nil" }
	var store: String { "nil" }
	var location: String { "nil" }
	
	init(expense: Expense) {
		self.expense = expense
	}
}
