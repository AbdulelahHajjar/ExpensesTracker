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
			Color(#colorLiteral(red: 0.1568627451, green: 0.8117647059, blue: 0.7019607843, alpha: 1))
				.edgesIgnoringSafeArea(.all)
			
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
