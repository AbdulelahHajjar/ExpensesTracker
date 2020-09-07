//
//  ExpenseCellView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 06/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct ExpenseCellView: View {
	@ObservedObject var viewModel: ExpenseCellViewModel
	
	@State private var isShowingEditExpenseView = false
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(String(viewModel.expense.amount))
				Text(String(viewModel.expense.timestamp.dateValue().shortDateTime))
			}
			
			Spacer()
			
			Button(action: {
				self.isShowingEditExpenseView = true
			}) {
				Image(systemName: "pencil.circle")
					.resizable()
					.scaledToFit()
					.frame(width: 24, height: 24)
					.foregroundColor(.blue)
			}
			.buttonStyle(BorderlessButtonStyle())
			.sheet(isPresented: self.$isShowingEditExpenseView) {
				EditExpenseView(viewModel: .init(expense: self.viewModel.expense))
			}
			
			
			Button(action: {
				self.viewModel.deleteExpense()
			}) {
				Image(systemName: "trash.circle")
					.resizable()
					.scaledToFit()
					.frame(width: 24, height: 24)
					.foregroundColor(.red)
			}
			.buttonStyle(BorderlessButtonStyle())
		}
	}
}

#if DEBUG
struct ExpenseCellView_Previews: PreviewProvider {
    static var previews: some View {
		ExpenseCellView(viewModel: .init(expense: .placeholder))
    }
}
#endif
