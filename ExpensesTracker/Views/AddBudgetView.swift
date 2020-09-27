//
//  AddBudgetView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct AddBudgetView: View {
	@ObservedObject var viewModel: AddBudgetViewModel
	
    var body: some View {
		NavigationView {
			Form {
				Section {
					TextField("Name (e.g. Food Budget)", text: $viewModel.name)
					
					TextField("Amount (e.g. 1500.0)", text: $viewModel.amount)
						.keyboardType(.decimalPad)
					
					TextField("Saving Percentage Goal (e.g. 25 Percent)", text: $viewModel.savingsPercentage)
						.keyboardType(.decimalPad)
					
					Picker(selection: $viewModel.repeatCycle, label: Text("Repeat Cycle")) {
						ForEach(viewModel.repeatCycles, id: \.self) { repeatCycle in
							Text(repeatCycle.rawValue).tag(repeatCycle)
						}
					}
					                    
					DatePicker(selection: $viewModel.startDate, in: viewModel.startDatePickerRange, displayedComponents: .date) { Text("Start Date") }
					                    
					if viewModel.showEndDatePicker {
						DatePicker(selection: $viewModel.endDate, in: viewModel.endDatePickerRange, displayedComponents: .date) { Text("End Date") }
					}
				}
				
				Section {
					Button(action: {
						viewModel.addBudget()
					}) {
						Text("Add Budget")
					}
				}
			}
		}
    }
}

struct AddBudgetView_Previews: PreviewProvider {
    static var previews: some View {
		AddBudgetView(viewModel: .init())
    }
}
