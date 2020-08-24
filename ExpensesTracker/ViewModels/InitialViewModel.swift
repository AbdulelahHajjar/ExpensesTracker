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
	
	let isSignedIn = CurrentValueSubject<Bool, Never>(false)
	
	private var cancellables = Set<AnyCancellable>()
	
	init() { setUpSubscribers() }
	
	func setUpSubscribers() {
		userDataRepository.$user
			.receive(on: DispatchQueue.main)
			.sink { self.isSignedIn.send($0 != nil) }
			.store(in: &cancellables)
	}
	
	func signOut() {
		userDataRepository.signOut()
	}
}
