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
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(viewModel.amount)
			Text(viewModel.timestamp)
			Text(viewModel.category)
			Text(viewModel.store)
			Text(viewModel.location)
			
			Color.black
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
