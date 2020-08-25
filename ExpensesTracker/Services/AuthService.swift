//
//  AuthService.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Firebase
import Combine

class AuthService: ObservableObject {
	static let shared                     = AuthService()
	
	@Published private(set) var authState : AuthState = .undetermined
	private var authStateChangeHandler    : AuthStateDidChangeListenerHandle?
	
	private init() { registerStateListener() }
	
	// MARK:- Authentication Operations
	func signUp(displayName: String, email: String, password: String, completion: @escaping (Error?) -> ()) {
		if Auth.auth().currentUser != nil { return }
		
		Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
			guard let authUser = result?.user else {
				completion(error ?? FirestoreError.unknown)
				return
			}
			
			let profileChangeRequest = authUser.createProfileChangeRequest()
			profileChangeRequest.displayName = displayName
			profileChangeRequest.commitChanges { _ in }
			
			let firestoreUser = UserData(id: authUser.uid, email: email, displayName: displayName)
			FirestoreService.shared.saveDocument(collection: .users, model: firestoreUser, completion: completion)
		}
	}
	
	func signIn(email: String, password: String, completion: @escaping (Error?) -> ()) {
		if Auth.auth().currentUser != nil { return }
		
		Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
			completion(error)
		}
	}
	
	func signOut() {
		try? Auth.auth().signOut()
	}
	
	// MARK:- Helpers
	private func registerStateListener() {
		if let handler = authStateChangeHandler {
			Auth.auth().removeStateDidChangeListener(handler)
		}
		
		self.authStateChangeHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
			guard let userID = user?.uid else {
				self.setAuthState(.signedOut)
				return
			}
			
			self.setAuthState(.signedIn(uid: userID))
		}
	}
	
	func setAuthState(_ authState: AuthState) {
		DispatchQueue.main.async { self.authState = authState }
	}
}
