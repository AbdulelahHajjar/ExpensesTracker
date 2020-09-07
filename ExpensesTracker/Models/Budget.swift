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
	var startTimestamp: Timestamp
	var endTimestamp: Timestamp
	let repeatCycle: Budget.RepeatCycle
	var previousBudgetID: Optional<String>
	var isActive: Bool
	
	var startDate       : Date		{ startTimestamp.dateValue() }
	var endDate         : Date		{ endTimestamp.dateValue() }
	var savingsAmount   : Double	{ savingsPercentage / 100.0 * amount }
	var budgetDays      : Int?		{ startDate.days(to: endDate) }
	var dailySpendLimit : Double?	{
		guard let denominator = budgetDays, denominator != 0 else { return nil }
		return (amount - savingsAmount) / Double(denominator)
	}
	
	enum CodingKeys: CodingKey {
		case id
		
		case name
		case amount
		case savingsPercentage
		case startTimestamp
		case endTimestamp
		case repeatCycle
		case previousBudgetID
		case isActive
	}
	
	enum RepeatCycle: String, Codable, CaseIterable {
		case never    = "Never"
		case daily    = "Daily"
		case weekly   = "Weekly"
		case biWeekly = "Biweekly"
		case monthly  = "Monthly"
		case yearly   = "Yearly"
		
		var numberOfDays: Int? {
			switch self {
				case .never    : return nil
				case .daily    : return 1
				case .weekly   : return 7
				case .biWeekly : return 14
				case .monthly  : return 30
				case .yearly   : return 365
			}
		}
	}
}

#if DEBUG
extension Budget {
	static let placeholder = Budget(id: UUID().uuidString,
									name: "Placeholder Budget",
									amount: 1000,
									savingsPercentage: 10,
									startTimestamp: Timestamp(date: Date()),
									endTimestamp: Timestamp(date: Date().addDays(30) ?? Date.tomorrow),
									repeatCycle: .never,
									previousBudgetID: nil,
									isActive: true)
}
#endif
