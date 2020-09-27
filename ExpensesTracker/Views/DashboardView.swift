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
		VStack(alignment: .center) {
			
			Text("Todays is: \(viewModel.today.shortDateTime)")
			
			HStack {
				Button(action: {
					isShowingBudgetSelector = true
				}) {
					Text("Select Budget")
				}
				.sheet(isPresented: $isShowingBudgetSelector) {
					Form {
						ForEach(viewModel.activeBudgets) { budget in
							Button(action: {
								viewModel.setDashboardBudget(id: budget.id)
								isShowingBudgetSelector = false
							}) {
								Text("\(budget.startDate.shortDate) -> \(budget.endDate.shortDate) [\(budget.status.rawValue)]")
									.foregroundColor(.black)
							}
						}
					}
					.navigationBarTitle("", displayMode: .inline)
				}
				
				Color.gray.frame(width: 1, height: 10)
				
				Button(action: {
					isShowingAddBudgetView = true
				}) {
					Text("Add Budget")
				}
				.sheet(isPresented: $isShowingAddBudgetView) {
					AddBudgetView(viewModel: .init())
				}
				
				Color.gray.frame(width: 1, height: 10)
				
				Button(action: {
					viewModel.deleteDashboardBudget()
				}) {
					Text("Delete Budget")
						.foregroundColor(.red)
				}
				.sheet(isPresented: $isShowingAddBudgetView) {
					AddBudgetView(viewModel: .init())
				}
			}
			
			if viewModel.dashboardBudget == nil {
				Text("You currently have no budgets.")
			} else {
				VStack(alignment: .leading) {
					Text("Raw Budget Values:")
						.fontWeight(.semibold)
					Text("Name:\t\t\t\t\t\(viewModel.dashboardBudget?.name ?? "[NA]")")
					Text("Amount:\t\t\t\t\(viewModel.dashboardBudget?.amount ?? -1)")
					Text("Saving %:\t\t\t\t\(viewModel.dashboardBudget?.savingsPercentage ?? -1)")
					Text("Start Date:\t\t\t\t\(viewModel.dashboardBudget?.startDate.shortDateTime ?? Date.distantPast.shortDateTime)")
					Text("End Date:\t\t\t\t\(viewModel.dashboardBudget?.endDate.shortDateTime ?? Date.distantPast.shortDateTime)")
					Text("Repeat Cycle:\t\t\t\(viewModel.dashboardBudget?.repeatCycle.rawValue ?? "[NA]")")
					Text("Status:\t\t\t\t\(String(viewModel.dashboardBudget?.status.rawValue ?? "[NA]"))")
						.padding(.bottom, 8)
				}
				
				NavigationLink(destination: ExpensesListView(viewModel: .init())) {
					Text("Expenses List For This Budget")
				}
				
				Color.gray
					.frame(height: 1)
					.padding(.bottom, 8)
				
				Text("Calculated Budget Values:")
					.fontWeight(.semibold)
				
				Text("Daily Spend Limit: \(viewModel.dailySpendLimit ?? -1)")
				Text("Total Spendings: \(viewModel.totalSpendings ?? -1)")
				Text("Todays Spendings: \(viewModel.todaySpendings ?? -1)")
				Spacer()
			}
		}
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
		DashboardView(viewModel: .init())
    }
}
