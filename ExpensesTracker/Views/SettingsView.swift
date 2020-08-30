//
//  SettingsView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 30/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	@ObservedObject var viewModel: SettingsViewModel
	
    var body: some View {
		Button(action: {
			self.viewModel.signOut()
		}) {
			Text("Sign Out")
		}
		.foregroundColor(.red)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		NavigationView {
			SettingsView(viewModel: .init())
		}
    }
}
