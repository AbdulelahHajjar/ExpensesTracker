//
//  BottomSheetView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 29/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
	var content: Content
	var extendedHeightMultiplier: CGFloat = 0.85
	var contractedHeightMultiplier: CGFloat = 0.50
	
	@State private var isExtended = false
	@State private var dragHeight: CGFloat = .zero
	private var contractedOffsetValue: CGFloat { (extendedHeightMultiplier - contractedHeightMultiplier) * screen.height }
	private var dragLeeway: CGFloat = 30
	private var maxExtendingDrag: CGFloat { (extendedHeightMultiplier - contractedHeightMultiplier) * screen.height + dragLeeway }
	private var dragTrigger = 60
	
	init(content: @escaping () -> Content) { self.content = content() }
	
    var body: some View {
		VStack {
			Spacer()
			
			content
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
			.padding(.vertical, 32)
			.padding(.horizontal, 28)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
			.shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: -10)
			.frame(height: extendedHeightMultiplier * screen.height + 30, alignment: .bottom)
			.offset(y: dragHeight)
			.offset(y: isExtended ? 0 + dragLeeway : contractedOffsetValue + dragLeeway)
			.gesture(
				DragGesture()
					.onChanged { value in
						withAnimation(.easeInOut(duration: 0.24)) {
							if abs(value.translation.height) > self.maxExtendingDrag {
								return
							}
							self.dragHeight = value.translation.height
						}
					}
					.onEnded { value in
						print(value.translation.height)
						print(self.isExtended)
						withAnimation(.easeInOut(duration: 0.24)) {
							if value.translation.height < -80 && !self.isExtended {
								print("here")
								self.isExtended = true
							}
							else if value.translation.height > 80 && self.isExtended {
								self.isExtended = false
							}
							self.dragHeight = .zero
						}
					}
			)
		}
		.edgesIgnoringSafeArea(.all)
    }
}

struct NewBottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
		DashboardView(viewModel: .init())
    }
}
