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
	let collection: FirestoreCollection
	
	func removeListener() { listenerRegistration.remove() }
}
