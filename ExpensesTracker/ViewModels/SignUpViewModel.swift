//
//  SignUpViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class SignUpViewModel: ObservableObject {
	@Published private var userDataRepository = UserDataRepository.shared
	
	@Published var firstName  	= ""
    @Published var lastName = ""
	@Published var email    = ""
	@Published var password = ""
	
	func signUp(completion: @escaping (Error?) -> (Void)) {
        userDataRepository.signUp(firstName: firstName, lastName: lastName, email: email, password: password, completion: completion)
	}
}
