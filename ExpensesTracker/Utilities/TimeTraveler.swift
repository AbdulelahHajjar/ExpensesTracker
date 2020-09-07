//
//  TimeTraveler.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 07/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

class TimeTraveler: ObservableObject {
	static let shared = TimeTraveler()
	@Published var date = Date()
	
	func travel(by timeInterval: TimeInterval) {
		date = date.addingTimeInterval(timeInterval)
	}
	
	func dayTravel(by days: Double) {
		travel(by: 24 * 60 * 60 * days)
	}
	
	func generateDate() -> Date {
		return date
	}
}
