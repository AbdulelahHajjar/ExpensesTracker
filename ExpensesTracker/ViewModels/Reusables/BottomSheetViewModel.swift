//
//  ExpensesBottomSheetViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class BottomSheetViewModel: ObservableObject {
	@Published private(set) var expenses = [Expense]()
	
	init(expenses: [Expense]) {
		self.expenses = expenses
	}
}
