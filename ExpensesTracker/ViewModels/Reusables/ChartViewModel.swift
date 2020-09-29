//
//  ChartViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class ChartViewModel: ObservableObject {
    private(set) var sortedRepresentableKeys: [String] = []
    private(set) var valuesSortedByKeys: [Double] = []

    private var rawData: [Date : Double]
    private var cancellables = Set<AnyCancellable>()
    
    init(rawData: [Date : Double]) {
        let representableData = Dictionary(uniqueKeysWithValues: rawData.map { key, value in (key.shortDate, value) })
        sortedRepresentableKeys = Array(rawData.keys.sorted()).map { $0.shortDate }
        valuesSortedByKeys = sortedRepresentableKeys.compactMap { representableData[$0] }
        self.rawData = rawData
    }
    
//    func registerSubscribers() {
//        $rawData
//            .map {
//                Dictionary(uniqueKeysWithValues: $0.map { key, value in (key.shortDate, value) })
//            }
//            .assign(to: \.representableData, on: self)
//            .store(in: &cancellables)
//        
//        $rawData
//            .map {
//                Array($0.keys.sorted()).map { $0.shortDate }
//            }
//            .assign(to: \.sortedRepresentableKeys, on: self)
//            .store(in: &cancellables)
//
//        $sortedRepresentableKeys
//            .map {
//                $0.compactMap { self.representableData[$0] }
//            }
//            .assign(to: \.valuesSortedByKeys, on: self)
//            .store(in: &cancellables)
//    }
}
