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
	let id = UUID().uuidString
	var amount    : Double
	var timestamp : Timestamp
//	var location  : CLLocation?
	var category  : Category?
	var store     : Store?
	
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
