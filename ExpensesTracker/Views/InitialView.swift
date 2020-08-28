//
//  InitialView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct InitialView: View {
	@ObservedObject var viewModel: InitialViewModel
	
	@State private var showSignUp = false
	@State private var showSignIn = false
	@State private var showHome = false
	
    var body: some View {
		NavigationView {
			VStack {
				Button(action: {
					self.showSignUp = true
				}) {
					Text("Sign Up")
				}
				.sheet(isPresented: $showSignUp) {
					SignUpView(viewModel: .init())
				}
								
				Button(action: {
					self.showSignIn = true
				}) {
					Text("Sign In")
				}
				.sheet(isPresented: $showSignIn) {
					SignInView(viewModel: .init())
				}
				
				NavigationLink(destination: HomeView(viewModel: .init()).navigationBarBackButtonHidden(true), isActive: $showHome) { EmptyView() }
			}
			.onReceive(viewModel.showHomeView) { self.showHome = $0 }
		}
		.overlay(
			Color.red
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.edgesIgnoringSafeArea(.all)
				.opacity(viewModel.extendLaunchScreen ? 1 : 0)
		)
	}
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
		InitialView(viewModel: .init())
    }
}
