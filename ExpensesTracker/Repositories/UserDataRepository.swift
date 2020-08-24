//
//  UserDataRepository.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class UserDataRepository: ObservableObject {
	static let shared                    = UserDataRepository()
	
	@Published private(set) var userData : UserData?
	@Published private var authService   = AuthService.shared
	private var cancellables             = Set<AnyCancellable>()

	private init() { registerSubscribers() }
	
	// MARK:- UserData CRUD
	private func loadUserData(uid: String) {
		FirestoreService.shared.getDocument(collection: .users, documentID: uid) { (result: Result<UserData, Error>) in
			switch result {
				case .success(let user): self.initializeUser(user)
				case .failure(_): self.signOut()
			}
		}
	}
	
	func signOut() {
		authService.signOut()
	}
	
	// MARK:- Helpers
	private func registerSubscribers() {
		authService.$authState
			.receive(on: DispatchQueue.main)
			.sink {
				switch $0 {
				case .signedIn(let uid): self.loadUserData(uid: uid)
				default: self.deInitializeUser()
				}
		}
		.store(in: &cancellables)
	}
	
	private func initializeUser(_ user: UserData) {
		DispatchQueue.main.async { self.userData = user }
	}
	
	private func deInitializeUser() {
		DispatchQueue.main.async { self.userData = nil }
	}
}
