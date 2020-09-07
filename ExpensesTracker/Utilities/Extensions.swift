//
//  Extensions.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine
import UIKit

/// Source: https://forums.swift.org/t/does-assign-to-produce-memory-leaks/29546/11
extension Publisher where Failure == Never {
	func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
		sink { [weak root] in
			root?[keyPath: keyPath] = $0
		}
	}
}

extension Collection {
	var jsonData: Data? {
		return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
	}
}

extension Data {
	var dictionary: [String : Any]? {
		return (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)).flatMap { $0 as? [String : Any] }
	}
}

extension FirestoreError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .invalidDocument: return NSLocalizedString("invalidDocument", comment: "")
		case .unknown: return NSLocalizedString("unknown", comment: "")
		}
	}
}

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

let screen = UIScreen.main.bounds

extension Date {
	static var tomorrow: Date { Date().addingTimeInterval(86_400) }
}

extension Date {
	func addDays(_ numberOfDays: Int) -> Date? {
		Calendar.current.date(byAdding: .day, value: numberOfDays, to: self)
	}
}
