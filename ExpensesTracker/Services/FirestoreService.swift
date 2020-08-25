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
	
	// MARK:- Firestore Operations
	func getDocuments<T: Codable & Identifiable>(collection: FirestoreCollection, attachListener: Bool, completion: @escaping (Result<[T], Error>) -> ()) {
		
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
			let listener = db.collection(collection.collectionPath).addSnapshotListener(handler)
			appendListenersArray(listener: listener, listenerType: .collectionListener(collectionPath: collection.collectionPath))
		} else {
			db.collection(collection.collectionPath).getDocuments(completion: handler)
		}
	}
	
	func getDocument<T: Codable & Identifiable>(collection: FirestoreCollection, documentID: String, attachListener: Bool, completion: @escaping (Result<T, Error>) -> ()) {
		let handler: FIRDocumentSnapshotBlock = { (documentSnapshot, error) in
			if let documentSnapshot = documentSnapshot {
				let decodeResult = self.decode(documentSnapshot: documentSnapshot, as: T.self)
				completion(decodeResult)
			}
		}
		
		if attachListener {
			let listener = db.collection(collection.collectionPath).document(documentID).addSnapshotListener(handler)
			appendListenersArray(listener: listener, listenerType: .documentListener(collectionPath: collection.collectionPath, documentID: documentID))
		} else {
			db.collection(collection.collectionPath).document(documentID).getDocument(completion: handler)
		}
	}
	
	func saveDocument<T: Codable & Identifiable>(collection: FirestoreCollection, model: T, completion: @escaping (Error?) -> ()) {
		do {
			try db.collection(collection.collectionPath).document("\(model.id)").setData(from: model, merge: false)
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
			.receive(on: DispatchQueue.main)
			.sink {
				if $0 == .signedOut || $0 == .undetermined {
					self.removeAllListeners()
				}
			}
			.store(in: &cancellables)
	}
}
