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
	static let shared                       = UserDataRepository()
	
	@Published private(set) var isDeterminingAuthState = true
	@Published private(set) var userData    : UserData? = nil
	@Published private var authService      = AuthService.shared
	@Published private var firestoreService = FirestoreService.shared
	private var cancellables                = Set<AnyCancellable>()

	private init() { registerSubscribers() }
    
    // MARK: - UserData CRUD
	private func loadUserData(uid: String) {
		firestoreService.getDocument(collection: .users, documentID: uid, attachListener: true) { (result: Result<UserData, Error>) in
			switch result {
            case .success(let user): self.initializeUser(user)
            case .failure(_): self.signOut()
			}
		}
	}
	
    func signUp(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Error?) -> (Void)) {
        authService.signUp(firstName: firstName, lastName: lastName, email: email, password: password, completion: completion)
	}
	
	func signIn(email: String, password: String, completion: @escaping (Error?) -> (Void)) {
		authService.signIn(email: email, password: password, completion: completion)
	}
	
	func signOut() {
		authService.signOut()
	}
	
	func updateUserData(_ userData: UserData, completion: @escaping (Error?) -> ()) {
		firestoreService.saveDocument(collection: .users, model: userData, completion: completion)
	}
	
	// MARK: - Helpers
	private func registerSubscribers() {
		authService.$authState
			.receive(on: DispatchQueue.main)
			.sink { state in
				switch state {
                    case .signedIn(let uid): self.loadUserData(uid: uid)
                    default: self.deInitializeUser()
				}
                self.isDeterminingAuthState = state == .undetermined ? true : false
			}
			.store(in: &cancellables)
	}
	
	private func initializeUser(_ user: UserData) {
        DispatchQueue.main.async { self.userData = user }
		print("UserDataRepository: Initialized UID \(user.id)")
	}
	
	private func deInitializeUser() {
		if userData == nil { return }
		print("UserDataRepository: Deinitialized UID \(userData?.id ?? "[NO ID]")")
        DispatchQueue.main.async { self.userData = nil }
	}
}
