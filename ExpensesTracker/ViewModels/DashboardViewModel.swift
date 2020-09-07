//
//  DashboardViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 05/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
	@Published private var budgetsRepository = BudgetsRepository.shared
	@Published private(set) var dashboardBudget: Budget? = .placeholder
	@Published private(set) var activeBudgets: [Budget] = []
	
	private var cancellables = Set<AnyCancellable>()
	
	init() { registerSubscribers() }
	
	func setDashboardBudget(id: String) {
		budgetsRepository.setDashboardBudgetID(id: id)
	}
	
	func deleteDashboardBudget() {
		guard let budget = dashboardBudget else { return }
		budgetsRepository.deleteBudget(budget) { error in
			// TODO: Error handling
		}
	}
	
	func registerSubscribers() {
		budgetsRepository.$budgets
			.receive(on: DispatchQueue.main)
			.map { budgets in
				budgets.filter { $0.isActive }
			}
			.assign(to: \.activeBudgets, on: self)
			.store(in: &cancellables)
		
		budgetsRepository.$dashboardBudgetID
			.receive(on: DispatchQueue.main)
			.map { budgetID in
				self.activeBudgets.first { $0.id == budgetID } ?? self.activeBudgets.first
			}
			.assign(to: \.dashboardBudget, on: self)
			.store(in: &cancellables)
	}
}
