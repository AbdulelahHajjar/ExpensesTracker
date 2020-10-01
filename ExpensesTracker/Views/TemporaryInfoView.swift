//
//  TemporaryInfoView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 30/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct TemporaryInfoView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    @State private var isShowingSelectBudgetView = false
    
    var body: some View {
        VStack {
            Text("Current Bugdet:\n\(viewModel.dashboardBudget?.id ?? "[NONE]")")
            
            Button(action: { isShowingSelectBudgetView = true }, label: {
                Text("Select from Active Budgets")
            })
            .sheet(isPresented: $isShowingSelectBudgetView, content: {
                Form {
                    ForEach(viewModel.activeBudgets) { budget in
                        Button(action: {
                            viewModel.setDashboardBudget(id: budget.id)
                            isShowingSelectBudgetView = false
                        }) {
                            Text("\(budget.startDate.shortDate) -> \(budget.endDate.shortDate) [\(budget.status.rawValue)]")
                                .foregroundColor(.black)
                        }
                    }
                }
                .navigationBarTitle("", displayMode: .inline)
            })
            
            NavigationLink(
                destination: ExpensesListView(viewModel: .init()),
                label: {
                    Text("Expenses for This Budget")
                })
                .disabled(viewModel.dashboardBudget == nil)
        }
    }
}

struct TemporaryInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TemporaryInfoView(viewModel: .init())
        }
    }
}
