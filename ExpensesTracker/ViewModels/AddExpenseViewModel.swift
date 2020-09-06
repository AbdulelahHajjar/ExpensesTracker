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
	
	@Published var amount: String = ""
	@Published var date: Date = Date()
	
	var doubleAmount: Double { Double(amount) ?? -1 }
	
	#warning("broken")
	func createExpense() {
//		expensesRepository.addExpense(Expense(id: UUID().uuidString, amount: doubleAmount, timestamp: Timestamp(date: date), category: nil, store: nil)) { error in
//			// TODO: Error handling
//		}
	}
}
