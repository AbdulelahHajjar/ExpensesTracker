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
	@Published var startDate         = Date() { willSet { if newValue >= endDate { endDate = newValue.addDays(1) ?? newValue } } }
	@Published var endDate           = Date.tomorrow
	@Published var repeatCycle       = Budget.RepeatCycle.never
	
	@Published private var budgetsRepository = BudgetsRepository.shared
	
	var showEndDatePicker    : Bool { repeatCycle == .never }
	var startDatePickerRange : ClosedRange<Date> { Date()...Date.distantFuture }
	var endDatePickerRange   : ClosedRange<Date> { (startDate.addDays(1) ?? startDate)...Date.distantFuture }
	var repeatCycles         : [Budget.RepeatCycle] { Budget.RepeatCycle.allCases }
	
	private var cancellables = Set<AnyCancellable>()
	
	private func getDate(repeatCycle: Budget.RepeatCycle, startDate: Date) -> Date? {
		guard let daysToIncrement = repeatCycle.numberOfDays else { return nil }
		return startDate.addDays(daysToIncrement)
	}
	
	func addBudget() {
		let budget = Budget(id: UUID().uuidString,
							name: name,
							amount: Double(amount) ?? -1,
							savingsPercentage: Double(savingsPercentage) ?? -1,
							startTimestamp: Timestamp(date: startDate),
							endTimestamp: Timestamp(date: (repeatCycle == .never ? endDate : getDate(repeatCycle: repeatCycle, startDate: startDate)) ?? Date()),
							repeatCycle: repeatCycle,
							previousBudgetID: nil,
							isActive: true)
		
		budgetsRepository.addBudget(budget) { error in
			// TODO: Error handling...
		}
	}
}
