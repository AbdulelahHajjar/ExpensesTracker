//
//  AuthService.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 03/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Firebase
import Combine

final class AuthService: ObservableObject {
	static let shared                     = AuthService()
	
	@Published private(set) var authState : AuthState = .undetermined
	private var authStateChangeHandler    : AuthStateDidChangeListenerHandle?
	
	private init() { registerStateListener() }
	
	// MARK: - Authentication Operations
    func signUp(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Error?) -> (Void)) {
		if Auth.auth().currentUser != nil { return }
		
		Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
			guard let authUser = result?.user else {
				completion(error ?? FirestoreError.unknown)
				return
			}
            let firestoreUser = UserData(id: authUser.uid, firstName: firstName, lastName: lastName, email: email)

			let profileChangeRequest = authUser.createProfileChangeRequest()
            profileChangeRequest.displayName = firestoreUser.fullName
			profileChangeRequest.commitChanges { _ in }
			
			FirestoreService.shared.saveDocument(collection: .users, model: firestoreUser, completion: completion)
		}
	}
	
	func signIn(email: String, password: String, completion: @escaping (Error?) -> (Void)) {
		if Auth.auth().currentUser != nil { return }
		
		Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
			completion(error)
		}
	}
	
	func signOut() {
		try? Auth.auth().signOut()
	}
	
	// MARK: - Helpers
	private func registerStateListener() {
		if let handler = authStateChangeHandler {
			Auth.auth().removeStateDidChangeListener(handler)
		}
		
		authStateChangeHandler = Auth.auth().addStateDidChangeListener { (auth, user) in
			guard let userID = user?.uid else {
                self.setAuthState(.signedOut)
				return
			}
			
            self.setAuthState(.signedIn(uid: userID))
		}
	}
	
    //MARK: - Setters
	private func setAuthState(_ authState: AuthState) {
        DispatchQueue.main.async { self.authState = authState }
	}
}

