//
//  RootTabView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct RootTabView: View {
    var body: some View {
		TabView {
			DashboardView(viewModel: .init())
				.tabItem {
					Image(systemName: "house")
					Text("Dashboard")
				}
			
			Text("3")
				.tabItem {
					Image(systemName: "house.fill")
					Text("Settings")
				}
		}
    }
}

struct RootTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootTabView()
    }
}

