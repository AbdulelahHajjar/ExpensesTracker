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
            NewDashboardView(viewModel: .init())
				.tabItem {
					Image(systemName: "house")
					Text("Dashboard")
				}
			
            TemporaryInfoView(viewModel: .init())
                .tabItem {
                    Image(systemName: "info")
                    Text("Information")
                }
            
			SettingsView(viewModel: .init())
				.tabItem {
					Image(systemName: "gear")
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

