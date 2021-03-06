//
//  SignInViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 23/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class SignInViewModel: ObservableObject {
	@Published private var userDataRepository = UserDataRepository.shared
	
	@Published var email = ""
	@Published var password = ""
	
	@Published private(set) var dismissModal = false
	
	func signIn() {
		// TODO: Check if valid email and password
		userDataRepository.signIn(email: email, password: password) { error in
			// TODO: Manage Completion Handler
            self.dismissModal = true
		}
	}
}
