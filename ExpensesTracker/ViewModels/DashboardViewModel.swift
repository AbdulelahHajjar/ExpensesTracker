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
	@Published private var expensesRepository = ExpensesRepository.shared
	@Published private var timeTraveler = TimeTraveler.shared
	
	@Published private(set) var dashboardBudget: Budget? = .placeholder
	@Published private(set) var activeBudgets: [Budget] = []
	@Published private(set) var expenses: [Expense] = []
	
	var dailySpendLimit: Double? { dashboardBudget?.dailySpendLimit }
	@Published var totalSpendings: Double? = nil
	@Published var todaySpendings: Double? = nil
	
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
		
		expensesRepository.$expenses
			.receive(on: DispatchQueue.main)
			.map { $0.map { $0.amount }.reduce(0) { $0 + $1 } }
			.assign(to: \.totalSpendings, on: self)
			.store(in: &cancellables)
		
		expensesRepository.$expenses
			.receive(on: DispatchQueue.main)
			.assign(to: \.expenses, on: self)
			.store(in: &cancellables)
		
		expensesRepository.$expenses
			.receive(on: DispatchQueue.main)
			.map {
				$0.filter { Calendar.current.isDate($0.timestamp.dateValue(), inSameDayAs: self.timeTraveler.date) }.map { $0.amount }.reduce(0) { $0 + $1 }
			}
			.assign(to: \.todaySpendings, on: self)
			.store(in: &cancellables)
		
		timeTraveler.$date
			.receive(on: DispatchQueue.main)
			.map { date in
				self.expenses.filter { Calendar.current.isDate($0.timestamp.dateValue(), inSameDayAs: date) }.map { $0.amount }.reduce(0) { $0 + $1 }
			}
			.assign(to: \.todaySpendings, on: self)
			.store(in: &cancellables)
	}
}
