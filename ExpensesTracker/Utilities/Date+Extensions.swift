//
//  Date+Extensions.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 26/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

extension Date {
	func localizedDescription(dateStyle: DateFormatter.Style = .medium,
							  timeStyle: DateFormatter.Style = .medium,
							  in timeZone : TimeZone = .current,
							  locale   : Locale = .current) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = locale
		dateFormatter.timeZone = timeZone
		dateFormatter.dateStyle = dateStyle
		dateFormatter.timeStyle = timeStyle
		return dateFormatter.string(from: self)
	}
	var localizedDescription: String { localizedDescription() }
}

extension Date {
	var fullDate: String   { localizedDescription(dateStyle: .full,   timeStyle: .none) }
	var longDate: String   { localizedDescription(dateStyle: .long,   timeStyle: .none) }
	var mediumDate: String { localizedDescription(dateStyle: .medium, timeStyle: .none) }
	var shortDate: String  { localizedDescription(dateStyle: .short,  timeStyle: .none) }
	
	var fullTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .full) }
	var longTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .long) }
	var mediumTime: String { localizedDescription(dateStyle: .none,   timeStyle: .medium) }
	var shortTime: String  { localizedDescription(dateStyle: .none,   timeStyle: .short) }
	
	var fullDateTime: String   { localizedDescription(dateStyle: .full,   timeStyle: .full) }
	var longDateTime: String   { localizedDescription(dateStyle: .long,   timeStyle: .long) }
	var mediumDateTime: String { localizedDescription(dateStyle: .medium, timeStyle: .medium) }
	var shortDateTime: String  { localizedDescription(dateStyle: .short,  timeStyle: .short) }
}

extension Date {
	static var tomorrow: Date { Date().addingTimeInterval(86_400) }
}

extension Date {
	func byAddingDays(_ numberOfDays: Double) -> Date {
		self.addingTimeInterval(numberOfDays * 86_400)
	}
}

extension Date {
	func years(to: Date) -> Int? {
		guard let years = Calendar.current.dateComponents([.year], from: self, to: to).year else { return nil }
		return abs(years)
	}
	
	func months(to: Date) -> Int? {
		guard let months = Calendar.current.dateComponents([.month], from: self, to: to).month else { return nil }
		return abs(months)
	}
	
	func days(to: Date) -> Int? {
		guard let days = Calendar.current.dateComponents([.day], from: self, to: to).day else { return nil }
		return abs(days)
	}
	
	func hours(to: Date) -> Int? {
		guard let hours = Calendar.current.dateComponents([.hour], from: self, to: to).hour else { return nil }
		return abs(hours)
	}
	
	func minutes(to: Date) -> Int? {
		guard let minutes = Calendar.current.dateComponents([.minute], from: self, to: to).minute else { return nil }
		return abs(minutes)
	}
	
	func seconds(to: Date) -> Int? {
		guard let seconds = Calendar.current.dateComponents([.second], from: self, to: to).second else { return nil }
		return abs(seconds)
	}
}
