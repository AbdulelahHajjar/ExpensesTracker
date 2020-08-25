//
//  HomeView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI
import Firebase

struct HomeView: View {
	@ObservedObject var viewModel: HomeViewModel
	
    var body: some View {
		List {
			ForEach(viewModel.expenses) { expense in
				VStack {
					Text("\(expense.amount)")
					Text("\(expense.timestamp.dateValue().shortDateTime)")
					Text("\(expense.id)")
				}
			}
		}
		.navigationBarTitle("Home")
		.navigationBarItems(trailing:
			
			HStack {
				Button(action: {
					self.viewModel.addExpense(Expense(amount: Double.random(in: 0...10), timestamp: Timestamp(date: Date()), category: nil, store: nil))
				}) {
					Text("Add Expense")
				}
				
				Button(action: {
					AuthService.shared.signOut()
				}) {
					Text("Log Out")
				}
			}
			
		)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			HomeView(viewModel: .init())
		}
    }
}
