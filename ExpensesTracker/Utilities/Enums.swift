//
//  Enums.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 19/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

enum FirestoreCollection {
	case users
	case users_expenses(userID: String)
	
	var collectionPath: String {
		switch self {
			case .users: return "users"
			case .users_expenses(let userID): return "users/\(userID)/expenses"
		}
	}
}

enum FirestoreError: Error {
	case invalidDocument
	case unknown
}

enum AuthState: Equatable {
	case undetermined
	case signedOut
	case signedIn(uid: String)
}
