//
//  ExpensesBottomSheetView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct BottomSheetView: View {
	@ObservedObject var viewModel: BottomSheetViewModel
	
	@State private var isShowingBottomSheet = false
	@State private var translation = CGSize.zero
	
	var extendedSheetSizePercentage: CGFloat = 0.80
	var contractedSheetSizePercentage: CGFloat = 0.45
	
	private var expandedSheetOffset   : CGFloat { screen.height - extendedSheetSizePercentage * screen.height }
	private var contractedSheetOffset : CGFloat { screen.height - contractedSheetSizePercentage * screen.height }
	private var maxExtendingDrag      : CGFloat { -(screen.height - contractedSheetOffset - dragLeeway) }
	private var maxContractingDrag    : CGFloat { contractedSheetSizePercentage * screen.height - dragLeeway }
	private var dragLeeway: CGFloat = 30
	private var dragThreshold: CGFloat = 80

	init(viewModel: BottomSheetViewModel) { self.viewModel = viewModel }
	
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
			.frame(height: screen.height - expandedSheetOffset)
			Spacer()
		}
		.padding(.vertical, 32)
		.padding(.horizontal, 28)
		.background(Color.white)
		.clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
		.shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 0)
		.offset(y: isShowingBottomSheet ? expandedSheetOffset : contractedSheetOffset)
		.offset(y: translation.height)
		.edgesIgnoringSafeArea(.all)
		.gesture(
			DragGesture()
				.onChanged { value in
					withAnimation(.easeInOut(duration: 0.2)) {
						if !self.isShowingBottomSheet && (value.translation.height > self.dragLeeway || value.translation.height < self.maxExtendingDrag) {
							return
						}
						else if self.isShowingBottomSheet && (value.translation.height < -self.dragLeeway || value.translation.height > self.maxContractingDrag) {
							return
						} else {
							self.translation = value.translation
						}
					}
				}
				
			.onEnded { value in
				withAnimation(.easeInOut(duration: 0.2)) {
					self.translation = .zero
					if value.translation.height < -self.dragThreshold {
						self.isShowingBottomSheet = true
					} else if value.translation.height > self.dragThreshold {
						self.isShowingBottomSheet = false
					}
				}
			}
		)
	}
}


struct ExpensesBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
		BottomSheetView(viewModel: .init(expenses: [.placeholder]))
    }
}
