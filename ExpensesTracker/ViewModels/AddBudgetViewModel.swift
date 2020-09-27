//
//  AddBudgetViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase
import Combine

final class AddBudgetViewModel: ObservableObject {
	@Published var name              = ""
	@Published var amount            = ""
	@Published var savingsPercentage = ""
	@Published var startDate         = Date() { willSet { if newValue >= endDate { endDate = newValue.byAddingDays(1) } } }
	@Published var endDate           = Date.tomorrow
	@Published var repeatCycle       = Budget.RepeatCycle.never
	
	@Published private var budgetsRepository = BudgetsRepository.shared
	
	var showEndDatePicker    : Bool { repeatCycle == .never }
	var startDatePickerRange : ClosedRange<Date> { Date()...startDate.byAddingDays(365) }
    var endDatePickerRange   : ClosedRange<Date> { startDate.byAddingDays(1)...startDate.byAddingDays(365) }
	var repeatCycles         : [Budget.RepeatCycle] { Budget.RepeatCycle.allCases }
	
	private var cancellables = Set<AnyCancellable>()
	
	func addBudget() {
		var budget: Budget
		
		if repeatCycle == .never {
			budget = Budget(id: UUID().uuidString,
							 name: name,
							 amount: Double(amount) ?? -1,
							 savingsPercentage: Double(savingsPercentage) ?? 0,
							 startDate: startDate,
							 endDate: endDate)!
		} else {
			budget = Budget(id: UUID().uuidString,
							 name: name,
							 amount: Double(amount) ?? -1,
							 savingsPercentage: Double(savingsPercentage) ?? 0,
							 repeatCycle: repeatCycle,
							 startDate: startDate)!
		}
		
		budgetsRepository.addBudget(budget) { error in
			// TODO: Error handling...
		}
	}
}
