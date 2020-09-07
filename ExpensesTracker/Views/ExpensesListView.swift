//
//  ExpensesListView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 06/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct ExpensesListView: View {
	@ObservedObject var viewModel: ExpensesListViewModel
	
	@State private var isShowingAddExpenseView = false
	
    var body: some View {
		List {
			ForEach(viewModel.expenseCellViewModels) { expenseCellViewModel in
				ExpenseCellView(viewModel: expenseCellViewModel)
			}
		}
		.navigationBarTitle("Expenses")
		.navigationBarItems(trailing:
			HStack {
				Button(action: {
					self.isShowingAddExpenseView = true
				}) {
					Image(systemName: "plus.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 24, height: 24)
				}
				.sheet(isPresented: self.$isShowingAddExpenseView) {
					AddExpenseView(viewModel: .init())
				}
			}
		)
    }
}

struct ExpensesListView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			ExpensesListView(viewModel: .init())
		}
    }
}


