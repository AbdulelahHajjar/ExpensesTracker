//
//  AddExpenseView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct AddExpenseView: View {
	@ObservedObject var viewModel: AddExpenseViewModel
	
    var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Amount", text: $viewModel.amount)
						.keyboardType(.decimalPad)
					DatePicker(selection: $viewModel.date, displayedComponents: .date) {
						Text("Date")
					}
				}
				
				Section {
					Button(action: {
						self.viewModel.createExpense()
					}) {
						Text("Add Expense")
					}
				}
			}
			.navigationBarTitle("Add Expense")
		}
    }
}

struct AddExpenseView_Previews: PreviewProvider {
    static var previews: some View {
		AddExpenseView(viewModel: .init())
    }
}

