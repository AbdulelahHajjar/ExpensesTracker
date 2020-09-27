//
//  Expense.swift
//  Expenses Tracker
//
//  Created by Abdulelah Hajjar on 05/07/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import CoreLocation
import Firebase

struct Expense: Identifiable, Codable {
	let id		  : String
	
	var amount    : Double
	private var timestamp : Timestamp
	
    var date: Date { timestamp.dateValue() }
    
    init(id: String, amount: Double, date: Date) {
        self.id = id
        self.amount = amount
        self.timestamp = Timestamp(date: date)
    }
    
    mutating func updateDate(_ date: Date) {
        self.timestamp = Timestamp(date: date)
    }
    
	enum CodingKeys: CodingKey {
		case id
		case amount
		case timestamp
	}
}

struct Category: Codable {}
struct Store: Codable {}

#if DEBUG
extension Expense {
    static let placeholder = Expense(id: UUID().uuidString, amount: 0, date: Date())
}
#endif
