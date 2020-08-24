//
//  SignUpViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

class SignUpViewModel: ObservableObject {
	@Published var authService = AuthService.shared
	
	@Published var name  	= ""
	@Published var email    = ""
	@Published var password = ""
	
	func signUp(completion: @escaping (Error?) -> ()) {
		AuthService.shared.signUp(displayName: name, email: email, password: password, completion: { completion($0) })
	}
}
