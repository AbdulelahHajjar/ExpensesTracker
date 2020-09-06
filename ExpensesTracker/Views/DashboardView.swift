//
//  DashboardView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 05/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
	@ObservedObject var viewModel: DashboardViewModel
	
	@State private var isShowingAddBudgetView = false
	@State private var isShowingBudgetSelector = false
	
    var body: some View {
		NavigationView {
			if viewModel.dashboardBudget == nil {
				Text("You currently have no budgets.")
			} else {
				VStack(alignment: .leading) {
					Text("Raw Budget Values:")
						.fontWeight(.semibold)
					Text("Name:\t\t\t\t\t\(viewModel.dashboardBudget?.name ?? "[NA]")")
					Text("Amount:\t\t\t\t\(viewModel.dashboardBudget?.amount ?? -1)")
					Text("Saving %:\t\t\t\t\(viewModel.dashboardBudget?.savingsPercentage ?? -1)")
					Text("Start Date:\t\t\t\t\(viewModel.dashboardBudget?.startDate.dateValue().shortDateTime ?? Date.distantPast.shortDateTime)")
					Text("End Date:\t\t\t\t\(viewModel.dashboardBudget?.endDate.dateValue().shortDateTime ?? Date.distantPast.shortDateTime)")
					Text("Repeat Cycle:\t\t\t\(viewModel.dashboardBudget?.repeatCycle.rawValue ?? "[NA]")")
					Text("Previous Budget ID:\t\(viewModel.dashboardBudget?.previousBudgetID ?? "[NA]")")
					Text("Is Active:\t\t\t\t\(String(viewModel.dashboardBudget?.isActive ?? false))")
				}
				
				Color.gray
					.frame(height: 1)
			}
		}
		.overlay(
			VStack {
				HStack {
					Button(action: {
						self.isShowingBudgetSelector = true
					}) {
						Text("Select Budget")
					}
					.sheet(isPresented: $isShowingBudgetSelector) {
						Form {
							ForEach(self.viewModel.activeBudgets) { budget in
								Button(action: {
									self.viewModel.setDashboardBudget(id: budget.id)
									self.isShowingBudgetSelector = false
								}) {
									Text(budget.name)
										.foregroundColor(.black)
								}
							}
						}
						.navigationBarTitle("", displayMode: .inline)
					}
					
					Color.gray.frame(width: 1, height: 10)
					
					Button(action: {
						self.isShowingAddBudgetView = true
					}) {
						Text("Add Budget")
					}
					.sheet(isPresented: $isShowingAddBudgetView) {
						AddBudgetView(viewModel: .init())
					}
					
					Color.gray.frame(width: 1, height: 10)
					
					Button(action: {
						self.viewModel.deleteDashboardBudget()
					}) {
						Text("Delete Budget")
							.foregroundColor(.red)
					}
					.sheet(isPresented: $isShowingAddBudgetView) {
						AddBudgetView(viewModel: .init())
					}
				}
				Spacer()
			}
		)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
		DashboardView(viewModel: .init())
    }
}
