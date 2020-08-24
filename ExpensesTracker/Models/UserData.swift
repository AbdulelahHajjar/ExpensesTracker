//
//  User.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import FirebaseFirestoreSwift

struct UserData: Identifiable, Codable {
	var id          : String
	var email       : String
	var displayName : String?
	
	private enum CodingKeys: CodingKey {
		case id
		case email
		case displayName
	}
}
