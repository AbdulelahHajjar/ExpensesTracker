//
//  SettingsViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 30/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class SettingsViewModel: ObservableObject {
	@Published var userDataRepository = UserDataRepository.shared
	
	func signOut() {
		userDataRepository.signOut()
	}
}
