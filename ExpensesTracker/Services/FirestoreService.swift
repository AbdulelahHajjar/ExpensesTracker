//
//  FirestoreService.swift
//  Expenses Tracker
//
//  Created by Abdulelah Hajjar on 01/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class FirestoreService: ObservableObject {
	static let shared                  = FirestoreService()
	
	@Published private var authService = AuthService.shared
	private let db                     = Firestore.firestore()
	private var cancellables           = Set<AnyCancellable>()
	private var snapshotListeners      = [FirestoreListener]()
	
	private init() { registerSubscribers() }
	
	// MARK:- Firestore Operations
	func getDocuments<T: Codable>(collection: FirestoreCollection, attachListener: Bool, completion: @escaping (Result<[T], Error>) -> ()) {
		let handler: FIRQuerySnapshotBlock = { (querySnapshot, error) in
			if let documents = querySnapshot?.documents {
				
				var modelArray = [T]()
				
				for document in documents {
					let decodeResult = self.decode(documentSnapshot: document, as: T.self)
					switch decodeResult {
						case .success(let model): modelArray.append(model)
						default: break
					}
					
				}
				completion(.success(modelArray))
			}
		}
		
		if attachListener {
			//TODO: Find a better way to manage listeners
			let listener = db.collection(collection.firestorePath).addSnapshotListener(handler)
			if snapshotListeners.map({ $0.collection }).contains(where: { $0.firestorePath == collection.firestorePath }) == false {
				snapshotListeners.append(.init(listenerRegistration: listener, collection: collection))
			}
		} else {
			db.collection(collection.firestorePath).getDocuments(completion: handler)
		}
	}
	
	func getDocument<T: Codable>(collection: FirestoreCollection, documentID: String, completion: @escaping (Result<T, Error>) -> ()) {
		db.collection(collection.firestorePath).document(documentID).getDocument { (documentSnapshot, error) in
			if let documentSnapshot = documentSnapshot {
				let decodeResult = self.decode(documentSnapshot: documentSnapshot, as: T.self)
				completion(decodeResult)
			}
		}
	}
	
	func saveDocument<T: Codable>(collection: FirestoreCollection, documentID: String, model: T, completion: @escaping (Error?) -> ()) {
		do {
			try db.collection(collection.firestorePath).document(documentID).setData(from: model, merge: false)
			completion(nil)
		} catch {
			completion(error)
		}
	}
	
	// MARK:- Helpers
	private func decode<T: Codable>(documentSnapshot: DocumentSnapshot, as: T.Type) -> Result<T, Error> {
		if let model = try? documentSnapshot.data(as: T.self) { return .success(model) }
		else { return .failure(FirestoreError.invalidDocument)}
	}
	
	private func removeAllListeners() {
		for index in snapshotListeners.indices {
			snapshotListeners[index].listenerRegistration.remove()
		}
		snapshotListeners.removeAll()
	}
	
	private func registerSubscribers() {
		authService.$authState
			.receive(on: DispatchQueue.main)
			.sink {
				if $0 == .signedOut || $0 == .undetermined {
					self.removeAllListeners()
				}
			}
			.store(in: &cancellables)
	}
}
