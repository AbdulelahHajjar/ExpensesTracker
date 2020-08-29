//
//  EditExpenseView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 30/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct EditExpenseView: View {
	@ObservedObject var viewModel: EditExpenseViewModel
	
    var body: some View {
		Form {
			Section {
				TextField("Amount", text: $viewModel.amount)
				
				DatePicker(selection: $viewModel.date, displayedComponents: .date) {
					Text("Date")
				}
			}
			
			Section {
				Button(action: {
					self.viewModel.updateExpense()
				}) {
					Text("Save Changes")
				}
			}
		}
    }
}

struct ExpenseEditorView_Previews: PreviewProvider {
    static var previews: some View {
		EditExpenseView(viewModel: .init(expense: .placeholder))
    }
}
