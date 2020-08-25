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
	
	private(set) var showHomeView = CurrentValueSubject<Bool, Never>(false)
	@Published private(set) var showLoadingOverlay = true
	
	private var cancellables = Set<AnyCancellable>()
	
	init() { registerSubscribers() }
	
	private func registerSubscribers() {
		userDataRepository.$userData
			.receive(on: DispatchQueue.main)
			.sink { self.showHomeView.send($0 != nil) }
			.store(in: &cancellables)
		
		userDataRepository.$isDeterminingAuthState
			.receive(on: DispatchQueue.main)
			.debounce(for: 1.5, scheduler: RunLoop.main)
			.assign(to: \.showLoadingOverlay, on: self)
			.store(in: &cancellables)
	}
	
	func signOut() {
		userDataRepository.signOut()
	}
}
