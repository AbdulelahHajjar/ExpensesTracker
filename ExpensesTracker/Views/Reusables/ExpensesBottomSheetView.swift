//
//  ExpensesBottomSheetView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct ExpensesBottomSheetView: View {
	@ObservedObject var viewModel: ExpensesBottomSheetViewModel
	@State var isShowingBottomSheet = false
	@State var translation = CGSize.zero
	
	var body: some View {
		VStack {
			HStack {
				Text("Expenses")
				Spacer()
				Image(systemName: "xmark")
			}
			.font(.headline)
			.padding(.bottom, 6)
			
			ScrollView {
				ForEach(viewModel.expenses) { expense in
					ExpenseCell(viewModel: .init(expense: expense))
				}
			}
			.disabled(!isShowingBottomSheet)
			
			Spacer()
		}
		.padding(.vertical, 32)
		.padding(.horizontal, 28)
		.background(Color.white)
		.clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
		.shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 0)
		.edgesIgnoringSafeArea(.all)
		.offset(y: isShowingBottomSheet ? 100 : 1.4 * screen.height / 3)
		.offset(y: translation.height)
		.gesture(
			DragGesture()
				.onChanged { value in
					withAnimation(.easeInOut(duration: 0.2)) {
						if self.isShowingBottomSheet == false && (value.translation.height > 40 || value.translation.height < -screen.height / 2.4) {
							self.translation = .zero
						}
						else if self.isShowingBottomSheet == true && (value.translation.height < -40 || value.translation.height > 1.4 * screen.height / 3) {
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
						self.isShowingBottomSheet = true
					} else if value.translation.height > 80 {
						self.isShowingBottomSheet = false
					}
				}
			}
		)
	}
}


struct ExpensesBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
		ExpensesBottomSheetView(viewModel: .init(expenses: [.placeholder]))
    }
}
