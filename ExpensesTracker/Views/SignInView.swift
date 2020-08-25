//
//  SignInView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct SignInView: View {
	@Environment(\.presentationMode) var presentationMode
	@ObservedObject var viewModel: SignInViewModel
	
    var body: some View {
		VStack {
			TextField("Email", text: $viewModel.email)
				.keyboardType(.emailAddress)
				.autocapitalization(.none)
			
			SecureField("Password", text: $viewModel.password)
			
			Button(action: signIn) { Text("Sign In") }
		}
    }
	
	func signIn() {
		viewModel.signIn()
	}
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
		SignInView(viewModel: .init())
    }
}
