//
//  FirestoreListener.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 24/08/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Firebase

struct FirestoreListener {
	let listenerRegistration: ListenerRegistration
	let listenerType: ListenerType
	
	func removeListener() {
		listenerRegistration.remove()
	}
}

enum ListenerType: Equatable {
	case collectionListener(collectionPath: String)
	case documentListener(collectionPath: String, documentID: String)
}
