//
//  Budget.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase

struct Budget: Identifiable, Equatable {
    let id                     : String
	
    var name                   : String
    var amount                 : Double
    var savingsPercentage      : Double
    let repeatCycle            : Budget.RepeatCycle
    private var startTimestamp : Timestamp
    private var endTimestamp   : Timestamp
    private(set) var status    : Budget.Status
    var insights               : Budget.Insights
	
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
		
        let endDate            = startDate.byAddingDays(Double(daysToIncrement))
        self.id                = id
        self.name              = name
        self.amount            = amount
		self.savingsPercentage = savingsPercentage
        self.repeatCycle       = repeatCycle
        self.startTimestamp    = Timestamp(date: startDate)
        self.endTimestamp      = Timestamp(date: endDate)
        self.status            = Budget.generateStatus(startDate: startDate, endDate: endDate)
        guard let insigts = Budget.Insights(startDate: startDate, endDate: endDate) else { return nil }
        self.insights           = insigts
	}
	
	init?(id: String, name: String, amount: Double, savingsPercentage: Double, startDate: Date, endDate: Date) {
		guard startDate < endDate, savingsPercentage <= 100 else { return nil }
		
        self.id                = id
        self.name              = name
        self.amount            = amount
		self.savingsPercentage = savingsPercentage
        self.repeatCycle       = .never
        self.startTimestamp    = Timestamp(date: startDate)
        self.endTimestamp      = Timestamp(date: endDate)
        self.status            = Budget.generateStatus(startDate: startDate, endDate: endDate)
        guard let insigts = Budget.Insights(startDate: startDate, endDate: endDate) else { return nil }
        self.insights           = insigts
	}
	
	mutating func archive() {
		status = .archived
	}
	
	mutating func activate() {
		status = .active
	}
}

// MARK: - Static Methods
extension Budget {
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
}

// MARK: - Codable
extension Budget: Codable {
    enum CodingKeys: CodingKey {
        case id
        
        case name
        case amount
        case savingsPercentage
        case startTimestamp
        case endTimestamp
        case repeatCycle
        case status
        case insights
    }
}

// MARK: - Enumerations
extension Budget {
    enum Status: String, Codable, CaseIterable {
        case active    = "Active"
        case archived  = "Archived"
        case scheduled = "Scheduled"
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
}

// MARK: - Structs
extension Budget {
    struct Insights: Codable, Equatable {
        var dailySpendings: [Date : Double]
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let _dailySpendings = try values.decode([String : Double].self, forKey: .dailySpendings)
            dailySpendings = Dictionary(uniqueKeysWithValues: _dailySpendings.map { key, value in (Date(timeIntervalSince1970: TimeInterval(key) ?? 0), value) })
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            let _dailySpendings = Dictionary(uniqueKeysWithValues: dailySpendings.map { key, value in ("\(key.timeIntervalSince1970)", value) })
            try container.encode(_dailySpendings, forKey: .dailySpendings)
        }
        
        init?(startDate: Date, endDate: Date) {
            guard let dailySpendings = Budget.Insights.generateDailySpendings(startDate: startDate, endDate: endDate) else { return nil }
            self.dailySpendings = dailySpendings
        }
        
        mutating func addToDailySpendings(date: Date, amount: Double) {
            guard let dateKey = dailySpendings.first(where: { Calendar.current.isDate($0.key, inSameDayAs: date) })?.key else { return }
            dailySpendings[dateKey] = (dailySpendings[dateKey] ?? 0) + amount
        }
        
        func spendingsInDay(of date: Date) -> Double? {
            for dailySpendingsDate in Array(dailySpendings.keys) {
                if Calendar.current.isDate(dailySpendingsDate, inSameDayAs: date) { return dailySpendings[dailySpendingsDate] }
            }
            return nil
        }
        
        
        static func generateDailySpendings(startDate: Date, endDate: Date) -> [Date : Double]? {
            var date = startDate
            var _dailySpendings = [Date : Double]()
            
            guard endDate > startDate else { return nil }
            
            while date <= endDate {
                _dailySpendings[date] = 0.0
                date = date.byAddingDays(1)
            }
            return _dailySpendings
        }
        
        enum CodingKeys: CodingKey {
            case dailySpendings
        }
    }
}

#if DEBUG
extension Budget {
	static let placeholder = Budget(id: UUID().uuidString,
									name: "Placeholder Budget",
									amount: 1000, savingsPercentage: 10,
									startDate: Date(),
									endDate: Date().byAddingDays(30))!
}
#endif
