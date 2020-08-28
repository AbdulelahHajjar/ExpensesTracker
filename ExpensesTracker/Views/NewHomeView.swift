//
//  NewHomeView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 26/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct NewHomeView: View {
	@State var expandExpensesList = false
	@State var translation = CGSize.zero
		
    var body: some View {
		ZStack {
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
						ExpenseCell()
					}
				}
				.disabled(true)
				
				Spacer()
			}
			
			.padding(.vertical, 32)
			.padding(.horizontal, 28)
			.animation(nil)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
			.offset(y: (expandExpensesList ? 100 : 1.4 * screen.height / 3) + translation.height)
			.animation(.default)
			.edgesIgnoringSafeArea(.all)
			.shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 0)
			.shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 0)
			.gesture(
				DragGesture()
					.onChanged { value in
						if self.expandExpensesList == false && (value.translation.height > 40 || value.translation.height < -screen.height / 2.4) {
							self.translation = .zero
							self.expandExpensesList = true
							return
						}
						
						if self.expandExpensesList == true && (value.translation.height < -40 || value.translation.height > 1.4 * screen.height / 3) {
							self.translation = .zero
							self.expandExpensesList = false
							return
						}
						
						self.translation = value.translation
					}
					.onEnded { value in
						self.translation = .zero
						if value.translation.height < -100 {
							self.expandExpensesList = true
						} else {
							self.expandExpensesList = false
						}
					}
			)
			
		}
		.background(Color(#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)).edgesIgnoringSafeArea(.all))
    }
}

struct NewHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NewHomeView()
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
