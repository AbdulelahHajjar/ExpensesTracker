//
//  DashboardView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 21/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
	@State private var firstColor = Color(#colorLiteral(red: 0, green: 0.5764705882, blue: 0.9137254902, alpha: 1))
	@State private var secondColor = Color(#colorLiteral(red: 0.5019607843, green: 0.8156862745, blue: 0.7803921569, alpha: 1))
	@State private var isShowingAddBudgetView = false
    @State private var isShowingSelectBudgetView = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: .init(stops: [.init(color: Color(#colorLiteral(red: 0.9019607843, green: 0.9333333333, blue: 0.9882352941, alpha: 1)), location: 0),
                                                   .init(color: Color(#colorLiteral(red: 0.937254902, green: 0.9529411765, blue: 0.9803921569, alpha: 1)), location: 0.5)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
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
                    
                    Spacer()
                }
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .overlay(
                BottomSheetView {
                    Text("I will have content soon!")
                }
                .opacity(1.00)
                .offset(y: 0.08 * screen.height)
            )
        }
    }
}

struct NewDashboardView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
            DashboardView(viewModel: .init())
		}
    }
}
