//
//  DashboardViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 05/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine
import UIKit

final class DashboardViewModel: ObservableObject {
	@Published private var budgetsRepository = BudgetsRepository.shared
	@Published private var expensesRepository = ExpensesRepository.shared
	@Published private var appStateRepository = AppStateRepository.shared
	
	@Published private(set) var today = Date()
	@Published private(set) var dashboardBudget: Budget? = nil
	@Published private(set) var activeBudgets: [Budget] = []
	@Published private(set) var expenses: [Expense] = []
    
    var graphValues: [String : Double] {
        guard let budget = dashboardBudget else { return [:] }
        return Dictionary(uniqueKeysWithValues: budget.insights.dailySpendings.map { key, value in (key.shortDate, value) })
    }
    
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
			.map { $0.filter { $0.status == .active } }
			.assign(to: \.activeBudgets, on: self)
			.store(in: &cancellables)
		
		expensesRepository.$expenses
			.receive(on: DispatchQueue.main)
			.assign(to: \.expenses, on: self)
			.store(in: &cancellables)
		
		appStateRepository.$today
			.assign(to: \.today, on: self)
			.store(in: &cancellables)
		
		budgetsRepository.$dashboardBudgetID
			.receive(on: DispatchQueue.main)
			.map { budgetID in
                self.activeBudgets.first { $0.id == budgetID } ?? self.activeBudgets.first
			}
			.assign(to: \.dashboardBudget, on: self)
			.store(in: &cancellables)
		
		$expenses
			.receive(on: DispatchQueue.main)
			.map { $0.map { $0.amount }.reduce(0) { $0 + $1 } }
			.assign(to: \.totalSpendings, on: self)
			.store(in: &cancellables)
		
		$expenses
			.receive(on: DispatchQueue.main)
			.map {
                self.calculateTodaySpendings(date: Date(), expenses: $0)
			}
			.assign(to: \.todaySpendings, on: self)
			.store(in: &cancellables)
		
		$today
			.receive(on: DispatchQueue.main)
			.sink { _ in
                self.todaySpendings = self.calculateTodaySpendings(date: Date(), expenses: self.expenses)
			}
			.store(in: &cancellables)
	}
	
	func calculateTodaySpendings(date: Date, expenses: [Expense]) -> Double {
		expenses.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }.map { $0.amount }.reduce(0) { $0 + $1 }
	}
}
