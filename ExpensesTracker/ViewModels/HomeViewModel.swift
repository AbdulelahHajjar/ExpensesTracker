//
//  HomeViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class HomeViewModel: ObservableObject {
	@Published var expensesRepository = ExpensesRepository.shared
	@Published var firestoreService = FirestoreService.shared
	
	func addExpense(_ expense: Expense) {
		
	}
}
