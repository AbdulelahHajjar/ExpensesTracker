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
//extension Publisher where Failure == Never {
//	func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
//		sink { [weak root] in
//			root?[keyPath: keyPath] = $0
//		}
//	}
//}

extension Collection {
	var jsonData: Data? {
		return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
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

let screen = UIScreen.main.bounds //Temporary
