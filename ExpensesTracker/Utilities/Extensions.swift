//
//  Extensions.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

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
