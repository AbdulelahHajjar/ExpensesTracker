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
	var timestamp : Timestamp
//	var location  : CLLocation?
	var category  : Optional<Category>
	var store     : Optional<Store>
	
	enum CodingKeys: CodingKey {
		case id
		case amount
		case timestamp
		case category
		case store
	}
}

struct Category: Codable {}
struct Store: Codable {}

#if DEBUG
extension Expense {
	static let placeholder = Expense(id: UUID().uuidString, amount: 0, timestamp: Timestamp(date: .init()), category: nil, store: nil)
}
#endif
