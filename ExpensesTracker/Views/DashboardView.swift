//
//  DashboardView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 26/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
	@ObservedObject var viewModel: DashboardViewModel
	
	@State private var isShowingAddExpenseView = false
	
	var body: some View {
		ZStack {
			Color(#colorLiteral(red: 0.5261384894, green: 0.8862745166, blue: 0.5152329912, alpha: 1))
				.edgesIgnoringSafeArea(.all)
			
			Button(action: {
				self.viewModel.temporarySignOut()
			}) {
				Text("Log Out")
			}
			.offset(y: -200)
			
			BottomSheetView {
				VStack {
					HStack {
						Text("Expenses")
						Spacer()
						
						Button(action: {
							self.isShowingAddExpenseView = true
						}) {
							Image(systemName: "plus.circle")
						}
						.sheet(isPresented: self.$isShowingAddExpenseView) {
							AddExpenseView(viewModel: .init())
						}
					}
					
					if self.viewModel.expenses.isEmpty == false {
						ScrollView {
							ForEach(self.viewModel.expenses) { expense in
								ExpenseCell(viewModel: .init(expense: expense))
							}
						}
					}
				}
			}
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		DashboardView(viewModel: .init())
	}
}
