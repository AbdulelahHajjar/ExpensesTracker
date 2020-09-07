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
	var startDate: Timestamp
	var endDate: Timestamp
	let repeatCycle: Budget.RepeatCycle
	var previousBudgetID: Optional<String>
	var isActive: Bool
	
	enum CodingKeys: CodingKey {
		case id
		
		case name
		case amount
		case savingsPercentage
		case startDate
		case endDate
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
									savingsPercentage: 20,
									startDate: Timestamp(date: Date()),
									endDate: Timestamp(date: Date.tomorrow),
									repeatCycle: .never,
									previousBudgetID: nil,
									isActive: true)
}
#endif
