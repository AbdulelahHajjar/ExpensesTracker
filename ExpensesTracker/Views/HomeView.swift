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
	
	@State var expandExpensesList = false
	@State var translation = CGSize.zero
	
	var body: some View {
		VStack {
			Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
				.edgesIgnoringSafeArea(.all)
		}
		.overlay(
			VStack {
				HStack {
					Text("Expenses")
					Spacer()
					Image(systemName: "xmark")
				}
				.font(.headline)
				.padding(.bottom, 6)
				
				ScrollView {
					ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
						Text("f")
					}
				}
				.disabled(true)
				
				Spacer()
			}
			.padding(.vertical, 32)
			.padding(.horizontal, 28)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
			.shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 0)
			.edgesIgnoringSafeArea(.all)
			.offset(y: expandExpensesList ? 100 : 1.4 * screen.height / 3)
			.offset(y: translation.height)
			.gesture(
				DragGesture()
					.onChanged { value in
						withAnimation(.easeInOut(duration: 0.2)) {
							if self.expandExpensesList == false && (value.translation.height > 40 || value.translation.height < -screen.height / 2.4) {
								self.translation = .zero
							}
							else if self.expandExpensesList == true && (value.translation.height < -40 || value.translation.height > 1.4 * screen.height / 3) {
								self.translation = .zero
							} else {
								self.translation = value.translation
							}
						}
				}
					
				.onEnded { value in
					withAnimation(.easeInOut(duration: 0.2)) {
						self.translation = .zero
						if value.translation.height < -80 {
							self.expandExpensesList = true
						} else if value.translation.height > 80 {
							self.expandExpensesList = false
						}
					}
				}
			)
		)
	}
}

struct NewHomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(viewModel: .init())
	}
}

struct ExpenseCell: View {
	var body: some View {
		VStack(alignment: .leading) {
			Text("5.00")
			Text("\(Date().shortDateTime)")
			Text("Category: nil")
			Text("Store: nil")
			Text("Location: nil")
			
			Color.black
				.frame(height: 1)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
	}
}
