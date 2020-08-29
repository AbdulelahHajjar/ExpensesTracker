//
//  ExpenseCell.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct ExpenseCell: View {
	@ObservedObject var viewModel: ExpenseCellViewModel
	
	@State private var isShowingEditExpenseView = false
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				VStack {
					Text(viewModel.id)
					Text(viewModel.amount)
					Text(viewModel.timestamp)
				}
				
				Spacer()
				
				Button(action: {
					self.isShowingEditExpenseView = true
				}) {
					Image(systemName: "pencil.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30)
				}
				.sheet(isPresented: $isShowingEditExpenseView) {
					EditExpenseView(viewModel: .init(expense: self.viewModel.expense))
				}
				
				Button(action: {
					self.viewModel.deleteExpense()
				}) {
					Image(systemName: "trash.circle")
						.resizable()
						.scaledToFit()
						.frame(width: 30, height: 30)
						.foregroundColor(.red)
				}
			}
			Color.gray
				.frame(height: 1)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}

struct ExpenseCell_Previews: PreviewProvider {
    static var previews: some View {
		ExpenseCell(viewModel: .init(expense: .placeholder))
    }
}
