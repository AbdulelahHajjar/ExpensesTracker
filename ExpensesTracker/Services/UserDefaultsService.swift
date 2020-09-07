//
//  LocalRepository.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 06/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation

final class UserDefaultsService: ObservableObject {
	static let shared    = UserDefaultsService()
	
	private let defaults = UserDefaults.standard
	private init() {}
	
	// MARK: - Primitive Operations
	func save(key: String, value: Any) {
		defaults.set(value, forKey: key)
	}
	
	func retrieve(key: String) -> Any? {
		return defaults.value(forKey: key)
	}
	
	// MARK: - Non-primitive Operations
	func save<T: Codable & Identifiable>(key: String, value: T) throws {
		do {
			let encodedData = try JSONEncoder().encode(key)
			guard let stringValue = String(data: encodedData, encoding: .utf8) else { throw UserDefaultsError.couldNotEncode }
			defaults.setValue(stringValue, forKey: key)
		} catch {
			print("LocalRepository: Could not save model, error: \(error.localizedDescription)")
			throw UserDefaultsError.couldNotSave
		}
	}
	
	func retrieve<T: Codable & Identifiable>(key: String, value: T) throws -> T {
		do {
			guard let fetchedData = (defaults.value(forKey: key) as? String)?.data(using: .utf8) else { throw UserDefaultsError.valueNotFound }
			let model = try JSONDecoder().decode(T.self, from: fetchedData)
			return model
		} catch {
			print("LocalRepository: Could not retrieve model, error: \(error.localizedDescription)")
			throw UserDefaultsError.couldNotRetrieve
		}
	}
}

extension UserDefaults {
	enum Keys {
		enum Budgets: String {
			case dashboardBudgetID = "lastViewedBudgetID"
		}
	}
}

enum UserDefaultsError: Error {
	case couldNotEncode
	case couldNotDecode
	
	case couldNotSave
	case couldNotRetrieve
	
	case valueNotFound
}
