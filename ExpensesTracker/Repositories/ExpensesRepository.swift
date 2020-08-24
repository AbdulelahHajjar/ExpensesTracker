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
	@Published var userDataRepository = UserDataRepository.shared
	@Published var firestoreService = FirestoreService.shared
	
	static var shared = ExpensesRepository()
	
	private var cancellables = Set<AnyCancellable>()

	init() {
		userDataRepository.$user
			.receive(on: DispatchQueue.main)
			.sink {
				if $0 != nil { self.attachDataListener() }
			}
			.store(in: &cancellables)
	}
	
	func attachDataListener() {
		if let user = userDataRepository.user {
			firestoreService.getDocuments(collection: .users_expenses(id: user.id), attachListener: true) { (result: Result<[Expense], Error>) in
				print("Getting expenses for \(user.displayName ?? "")")
			}
		} else {
			print("there is no user to get expenses for")
		}
	}
	
	func addExpense(_ expense: Expense) {
		if let user = userDataRepository.user {
			firestoreService.saveDocument(collection: .users_expenses(id: user.id), documentID: expense.id, model: expense) { error in
				print(error == nil ? "Expense saved!" : "Error while saving expense")
			}
		}
	}
}
