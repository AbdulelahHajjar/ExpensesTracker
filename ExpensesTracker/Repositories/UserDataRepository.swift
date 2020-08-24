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
	static let shared = UserDataRepository()
	
	@Published private var authService = AuthService.shared
	@Published private(set) var user   : UserData?
	
	private var cancellables           = Set<AnyCancellable>()

	private init() {
		authService.$authState
			.receive(on: DispatchQueue.main)
			.sink {
				switch $0 {
					case .signedIn(let uid): self.retrieveUser(uid: uid)
					default: self.deInitializeUser()
				}
			}
			.store(in: &cancellables)
	}
	
	private func initializeUser(_ user: UserData) {
		DispatchQueue.main.async { self.user = user }
	}
	
	private func deInitializeUser() {
		DispatchQueue.main.async { self.user = nil }
	}
	
	func signOut() {
		authService.signOut()
	}
	
	private func retrieveUser(uid: String) {
		FirestoreService.shared.getDocument(collection: .users, documentID: uid) { (result: Result<UserData, Error>) in
			switch result {
			case .success(let user): self.initializeUser(user)
			case .failure(_): self.signOut()
			}
		}
	}
}
