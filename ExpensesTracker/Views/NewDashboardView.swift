//
//  NewDashboardView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 21/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct NewDashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
	@State private var firstColor = Color(#colorLiteral(red: 0, green: 0.5764705882, blue: 0.9137254902, alpha: 1))
	@State private var secondColor = Color(#colorLiteral(red: 0.5019607843, green: 0.8156862745, blue: 0.7803921569, alpha: 1))
	@State private var isShowingAddBudgetView = false
    @State private var isShowingSelectBudgetView = false
    
    var body: some View {
		VStack(alignment: .leading) {
            if let budget = viewModel.dashboardBudget {
                HStack {
                    Text("Hello, Abdulelah!")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.bottom)
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("SR 30.00")
                        .font(.title)
                    
                    Text("+SR 1.50")
                        .font(.footnote)
                        .foregroundColor(.green)
                        .padding(.bottom, 4)
                }
                
                Text("Today's allowance")
                    .foregroundColor(Color(#colorLiteral(red: 0.4745098039, green: 0.4745098039, blue: 0.4745098039, alpha: 1)))
                    .fontWeight(.light)
                
                ChartView(viewModel: .init(rawData: budget.insights.dailySpendings), isCurvedLine: true, firstColor: firstColor, secondColor: secondColor)
                    .frame(height: 200)
                
                HStack {
                    Text("4W")
                        .bold()
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: .init(colors: [firstColor, secondColor]), startPoint: .bottomLeading, endPoint: .topTrailing))
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 8)
                        .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
                }
                
                Spacer()
            }
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding()
		.background(
            LinearGradient(gradient: .init(stops: [.init(color: Color(#colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 0.9882352941, alpha: 1)), location: 0),
                                                   .init(color: Color(#colorLiteral(red: 0.937254902, green: 0.9529411765, blue: 0.9803921569, alpha: 1)), location: 0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        
		.navigationBarTitle("")
		.navigationBarHidden(true)
		.overlay(
			BottomSheetView {
                Text("I will have content soon!")
			}
            .opacity(1.00)
            .offset(y: 100)
		)
    }
}

struct NewDashboardView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
            NewDashboardView(viewModel: .init())
		}
    }
}

struct LineGraph: Shape {
	var dataPoints: [CGFloat]
	
	func path(in rect: CGRect) -> Path {
		func point(at ix: Int) -> CGPoint {
			let point = dataPoints[ix]
			let x = rect.width * CGFloat(ix) / CGFloat(dataPoints.count - 1)
			let y = (1-point) * rect.height
			return CGPoint(x: x, y: y)
		}
		
		return Path { p in
			guard dataPoints.count > 1 else { return }
			let start = dataPoints[0]
			p.move(to: CGPoint(x: 0, y: (1-start) * rect.height))
			for idx in dataPoints.indices {
				p.addLine(to: point(at: idx))
			}
		}
	}
}
