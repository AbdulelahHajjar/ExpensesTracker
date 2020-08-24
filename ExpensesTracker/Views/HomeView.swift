//
//  HomeView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel: HomeViewModel
	
    var body: some View {
		VStack {
			Text("Hello, World!")
			Button(action: {
				AuthService.shared.signOut()
			}) {
				Text("Sign Out")
			}
			
			Button(action: {
				self.viewModel.addExpense(Expense(amount: 1, timestamp: .init(date: Date()), category: nil, store: nil))
			}) {
				Text("Add Expense")
			}
			
			Button(action: {

			}) {
				Text("Reset User")
			}
		}
		.navigationBarTitle("Home")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			HomeView(viewModel: .init())
		}
    }
}
