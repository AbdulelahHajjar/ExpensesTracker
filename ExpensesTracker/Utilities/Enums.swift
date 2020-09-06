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
	case users_budgets_expenses(userID: String, budgetID: String) //deleteLater
	case users_budgets(userID: String)
	
	var collectionPath: String {
		switch self {
			case .users: return "users"
			case .users_budgets_expenses(userID: let userID, budgetID: let budgetID): return "users/\(userID)/budgets/\(budgetID)"
			case .users_budgets(let userID): return "users/\(userID)/budgets"
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


