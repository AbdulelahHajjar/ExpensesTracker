//
//  NewBottomSheetView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 29/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct NewBottomSheetView<Content: View>: View {
	var content: () -> Content
	var extendedHeightMultiplier: CGFloat = 0.75
	var contractedHeightMultiplier: CGFloat = 0.50
	
	@State private var isExtended = false
	@State private var dragHeight: CGFloat = .zero
	private var contractedOffsetValue: CGFloat { (extendedHeightMultiplier - contractedHeightMultiplier) * screen.height }
	private var dragLeeway: CGFloat = 20
	private var maxExtendingDrag: CGFloat { (extendedHeightMultiplier - contractedHeightMultiplier) * screen.height}
	private var dragTrigger = 60
	
	init(content: @escaping () -> Content) { self.content = content }
	
    var body: some View {
		VStack {
			Spacer()
			
			content()
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
							if !self.isExtended && value.translation.height > self.dragLeeway ||
								self.isExtended && value.translation.height < -self.dragLeeway {
								self.dragHeight = .zero
								return
							}
							
							if abs(value.translation.height) > self.maxExtendingDrag {
								self.isExtended.toggle()
								self.dragHeight = .zero
								return
							}
							
							self.dragHeight = value.translation.height
						}
					}
					.onEnded { value in
						withAnimation(.easeInOut(duration: 0.24)) {
							if abs(self.dragHeight) > 60 {
								self.isExtended.toggle()
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
