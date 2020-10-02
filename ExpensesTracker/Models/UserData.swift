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
	let id          : String
    
    var firstName: String
    var lastName: String
	var email       : String
    
    var fullName: String { firstName + " " + lastName }
    
	private enum CodingKeys: CodingKey {
		case id
        case firstName
        case lastName
		case email
	}
}
