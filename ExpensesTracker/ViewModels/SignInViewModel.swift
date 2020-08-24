//
//  SignInViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 23/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class SignInViewModel: ObservableObject {
	@Published var authService = AuthService.shared
	
	@Published var email = ""
	@Published var password = ""
	
	func signIn(completion: @escaping (Error?) -> ()) {
		authService.signIn(email: email, password: password) { completion($0) }
	}
}
