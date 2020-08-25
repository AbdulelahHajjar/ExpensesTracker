//
//  HomeViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
	@Published private var expensesRepository = ExpensesRepository.shared
	@Published private var firestoreService = FirestoreService.shared
	
	@Published private(set) var expenses = [Expense]()
	
	var cancellables = Set<AnyCancellable>()
	
	init() {
		registerSubscribers()
	}
	
	private func registerSubscribers() {
		expensesRepository.$expenses
			.sink { self.expenses = $0 }
			.store(in: &cancellables)
	}
	
	func addExpense(_ expense: Expense) {
		self.expensesRepository.addExpense(expense) { error in
			// TODO: Implement handling
		}
	}
}
