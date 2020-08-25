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
	private var cancellables                  = Set<AnyCancellable>()
	
	private init() { registerSubscribers() }
	
	// MARK:- Expenses CRUD
	func addExpense(_ expense: Expense, completion: @escaping (Error?) -> ()) {
		guard let user = userDataRepository.userData else { return }
		firestoreService.saveDocument(collection: .users_expenses(userID: user.id), model: expense, completion: completion)
	}
	
	// MARK:- Helpers
	private func loadExpenses() {
		guard let userID = userDataRepository.userData?.id else { return }
		
		firestoreService.getDocuments(collection: .users_expenses(userID: userID), attachListener: true) { (result: Result<[Expense], Error>) in
			DispatchQueue.main.async {
				switch result {
					case .success(let expenses):
						self.expenses = expenses
						print("ExpensesRepository: Downloaded \(expenses.count) Expense\(expenses.count == 1 ? "" : "s")")
					case .failure(_): break
				}
			}
		}
	}
	
	private func registerSubscribers() {
		userDataRepository.$userData
			.receive(on: DispatchQueue.main)
			.sink {
				if $0 != nil { self.loadExpenses() }
		}
		.store(in: &cancellables)
	}
}
