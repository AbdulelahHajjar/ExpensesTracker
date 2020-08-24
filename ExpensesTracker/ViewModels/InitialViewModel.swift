//
//  InitialViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase
import Combine

class InitialViewModel: ObservableObject {
	@Published private var userDataRepository = UserDataRepository.shared
	
	@Published var isSignedIn: Bool = false
	@Published var showLoadingOverlay = true
	
	private var cancellables = Set<AnyCancellable>()
	
	init() { registerSubscribers() }
	
	func registerSubscribers() {
		userDataRepository.$userData
			.receive(on: DispatchQueue.main)
			.map { $0 != nil }
			.assign(to: \.isSignedIn, on: self)
			.store(in: &cancellables)
		
		userDataRepository.$isDeterminingAuthState
			.receive(on: DispatchQueue.main)
			.debounce(for: 1.4, scheduler: RunLoop.main)
			.assign(to: \.showLoadingOverlay, on: self)
			.store(in: &cancellables)
	}
	
	func signOut() {
		userDataRepository.signOut()
	}
}
