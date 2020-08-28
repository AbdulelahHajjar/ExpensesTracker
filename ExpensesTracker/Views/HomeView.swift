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
		ZStack {
			Color(#colorLiteral(red: 0.5261384894, green: 0.8862745166, blue: 0.5152329912, alpha: 1))
				.edgesIgnoringSafeArea(.all)
			Button(action: {
				self.viewModel.temporarySignOut()
			}) {
				Text("Log Out")
			}
			.offset(y: -100)
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
