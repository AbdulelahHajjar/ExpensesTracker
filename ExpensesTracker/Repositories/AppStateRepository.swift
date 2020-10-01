//
//  AppStateRepository.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 18/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class AppStateRepository: ObservableObject {
	static let shared = AppStateRepository()
	
	@Published private(set) var today = Date()
	
	private var cancellables = Set<AnyCancellable>()
	
	private init() { registerSubscribers() }
	
	private func registerSubscribers() {
		NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
            .sink { _ in self.today = Date() }
			.store(in: &cancellables)
	}
}
