//
//  ContentView.swift
//  Expenses Tracker
//
//  Created by Abdulelah Hajjar on 27/06/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel: SignUpViewModel
	
    var body: some View {
		Form {
			TextField("First Name", text: $viewModel.firstName)
            
            TextField("Last Name", text: $viewModel.lastName)

			TextField("Email", text: $viewModel.email)
				.keyboardType(.emailAddress)
				.autocapitalization(.none)
			
			SecureField("Password", text: $viewModel.password)
			
			Button(action: signUp, label: { Text("Sign Up") })
		}
    }
	
	func signUp() {
		viewModel.signUp { error in
			// TODO:- Error handling
			presentationMode.wrappedValue.dismiss()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		SignUpView(viewModel: SignUpViewModel())
    }
}
