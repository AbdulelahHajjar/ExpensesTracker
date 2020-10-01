//
//  FirestoreService.swift
//  Expenses Tracker
//
//  Created by Abdulelah Hajjar on 01/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

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
	
	// MARK: - Firestore Operations
	func getDocuments<T: Codable & Identifiable>(collection: FirestoreCollection,
												 attachListener: Bool,
												 completion: @escaping (Result<[T], Error>) -> (Void)) {
        
		let handler: FIRQuerySnapshotBlock = { (querySnapshot, error) in
			guard let documents = querySnapshot?.documents else {
				completion(.failure(FirestoreError.unknown))
				return
			}
			
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
		
		if attachListener {
			//TODO: Find a better way to manage listeners
			let listener = db.collection(collection.path).addSnapshotListener(handler)
			appendListenersArray(listener: listener, listenerType: .collectionListener(collectionPath: collection.path))
		} else {
			db.collection(collection.path).getDocuments(completion: handler)
		}
	}
	
	func getDocument<T: Codable & Identifiable>(collection: FirestoreCollection,
												documentID: String,
												attachListener: Bool,
												completion: @escaping (Result<T, Error>) -> (Void)) {
		
		let handler: FIRDocumentSnapshotBlock = { (documentSnapshot, error) in
			guard let documentSnapshot = documentSnapshot else {
				completion(.failure(FirestoreError.unknown))
				return
			}
			
            let decodeResult = self.decode(documentSnapshot: documentSnapshot, as: T.self)
			completion(decodeResult)
		}
		
		if attachListener {
			let listener = db.collection(collection.path).document(documentID).addSnapshotListener(handler)
			appendListenersArray(listener: listener, listenerType: .documentListener(collectionPath: collection.path, documentID: documentID))
		} else {
			db.collection(collection.path).document(documentID).getDocument(completion: handler)
		}
	}
	
	func saveDocument<T: Codable & Identifiable>(collection: FirestoreCollection, model: T, completion: @escaping (Error?) -> (Void)) {
		do {
			try db.collection(collection.path).document("\(model.id)").setData(from: model, merge: false)
			completion(nil)
		} catch {
			completion(error)
		}
	}
	
	func deleteDocument<T: Codable & Identifiable>(collection: FirestoreCollection, model: T, completion: @escaping (Error?) -> (Void)) {
		db.collection(collection.path).document("\(model.id)").delete(completion: completion)
	}
	
	// MARK: - Helpers
	private func decode<T: Codable>(documentSnapshot: DocumentSnapshot, as: T.Type) -> Result<T, Error> {
		if let model = try? documentSnapshot.data(as: T.self) { return .success(model) }
		else { return .failure(FirestoreError.invalidDocument)}
	}
	
	private func appendListenersArray(listener: ListenerRegistration, listenerType: ListenerType) {
		if snapshotListeners.map({ $0.listenerType }).contains(listenerType) == false {
			snapshotListeners.append(.init(listenerRegistration: listener, listenerType: listenerType))
		}
	}
	
	private func removeAllListeners() {
		for index in snapshotListeners.indices {
			snapshotListeners[index].listenerRegistration.remove()
		}
		snapshotListeners.removeAll()
	}
	
	private func registerSubscribers() {
		authService.$authState
			.sink {
				if $0 == .signedOut || $0 == .undetermined {
                    self.removeAllListeners()
				}
			}
			.store(in: &cancellables)
	}
}
