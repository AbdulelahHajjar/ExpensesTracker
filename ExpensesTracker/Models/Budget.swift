//
//  Budget.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase

struct Budget: Identifiable, Codable, Equatable {
	let id: String
	
	var name: String
	var amount: Double
	var savingsPercentage: Double
	let repeatCycle: Budget.RepeatCycle
	private var startTimestamp: Timestamp
	private var endTimestamp: Timestamp
	private(set) var status: Budget.Status
	
	var startDate       : Date		{ startTimestamp.dateValue() }
	var endDate         : Date		{ endTimestamp.dateValue() }
	var savingsAmount   : Double	{ savingsPercentage / 100.0 * amount }
	var budgetDays      : Int?		{ startDate.days(to: endDate) }
	var dailySpendLimit : Double?	{
		guard let denominator = budgetDays, denominator != 0 else { return nil }
		return (amount - savingsAmount) / Double(denominator)
	}
	
	init?(id: String, name: String, amount: Double, savingsPercentage: Double, repeatCycle: Budget.RepeatCycle, startDate: Date) {
		guard let daysToIncrement = repeatCycle.numberOfDays, savingsPercentage <= 100 else { return nil }
		
		let endDate = startDate.byAddingDays(Double(daysToIncrement))
		self.id = id
		self.name = name
		self.amount = amount
		self.savingsPercentage = savingsPercentage
		self.repeatCycle = repeatCycle
		self.startTimestamp = Timestamp(date: startDate)
		self.endTimestamp = Timestamp(date: endDate)
		self.status = Budget.generateStatus(startDate: startDate, endDate: endDate)
	}
	
	init?(id: String, name: String, amount: Double, savingsPercentage: Double, startDate: Date, endDate: Date) {
		guard startDate < endDate, savingsPercentage <= 100 else { return nil }
		
		self.id = id
		self.name = name
		self.amount = amount
		self.savingsPercentage = savingsPercentage
		self.repeatCycle = .never
		self.startTimestamp = Timestamp(date: startDate)
		self.endTimestamp = Timestamp(date: endDate)
		self.status = Budget.generateStatus(startDate: startDate, endDate: endDate)
	}
	
	mutating func archive() {
		status = .archived
	}
	
	mutating func activate() {
		status = .active
	}
	
	static func generateStatus(startDate: Date, endDate: Date) -> Budget.Status {
		var status: Budget.Status
		let currentDate = Date()
		
		if startDate <= currentDate && endDate <= currentDate {
			status = .archived
		} else if startDate <= currentDate && endDate > currentDate {
			status = .active
		} else if startDate > currentDate && endDate > currentDate {
			status = .scheduled
		} else {
			status = .archived
		}
		
		return status
	}
	
	enum CodingKeys: CodingKey {
		case id
		
		case name
		case amount
		case savingsPercentage
		case startTimestamp
		case endTimestamp
		case repeatCycle
		case status
	}
	
	enum RepeatCycle: String, Codable, CaseIterable {
		case never    = "Never"
		case daily    = "Daily"
		case weekly   = "Weekly"
		case biweekly = "Biweekly"
		case monthly  = "Monthly"
		case yearly   = "Yearly"
		
		var numberOfDays: Int? {
			switch self {
				case .never    : return nil
				case .daily    : return 1
				case .weekly   : return 7
				case .biweekly : return 14
				case .monthly  : return 30
				case .yearly   : return 365
			}
		}
	}
	
	enum Status: String, Codable, CaseIterable {
		case active    = "Active"
		case archived  = "Archived"
		case scheduled = "Scheduled"
	}
}

#if DEBUG
extension Budget {
	static let placeholder = Budget(id: UUID().uuidString,
									name: "Placeholder Budget",
									amount: 1000, savingsPercentage: 10,
									startDate: Date(),
									endDate: Date().byAddingDays(1))
}
#endif
