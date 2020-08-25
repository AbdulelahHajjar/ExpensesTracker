//
//  SignUpViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

class SignUpViewModel: ObservableObject {
	@Published private var userDataRepository = UserDataRepository.shared
	
	@Published var displayName  	= ""
	@Published var email    = ""
	@Published var password = ""
	
	func signUp(completion: @escaping (Error?) -> (Void)) {
		userDataRepository.signUp(displayName: displayName, email: email, password: password) { error in
			
		}
	}
}
