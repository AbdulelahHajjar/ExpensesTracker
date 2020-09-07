//
//  ExpensesListViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 06/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class ExpensesListViewModel: ObservableObject {
	@Published private var expensesRepository = ExpensesRepository.shared
	@Published var expenseCellViewModels = [ExpenseCellViewModel]()
	
	private var cancellables = Set<AnyCancellable>()
	
	init() { registerSubscribers() }
	
	private func registerSubscribers() {
		expensesRepository.$expenses
			.receive(on: DispatchQueue.main)
			.map { expenses in
				expenses.map { ExpenseCellViewModel(expense: $0) }
			}
			.assign(to: \.expenseCellViewModels, on: self)
			.store(in: &cancellables)
	}
}
