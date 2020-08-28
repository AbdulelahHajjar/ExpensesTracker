//
//  NewHomeView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 26/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel: HomeViewModel
	
	var body: some View {
		VStack {
			Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
				.edgesIgnoringSafeArea(.all)
		}
		.overlay(
			ExpensesBottomSheetView(viewModel: .init(expenses: viewModel.expenses))
		)
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(viewModel: .init())
	}
}
