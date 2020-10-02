//
//  ChartViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 28/09/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class BudgetInsightsChartViewModel: ObservableObject {
    

    private var rawData: [Date : Double]
    private var cancellables = Set<AnyCancellable>()
    
    init(sortedRepresentableKeys: [String], valuesSortedByKeys: Double) {
//        let representableData = Dictionary(uniqueKeysWithValues: rawData.map { key, value in (key.shortDate, value) })
//        sortedRepresentableKeys = Array(rawData.keys.sorted()).map { $0.shortDate }
//        valuesSortedByKeys = sortedRepresentableKeys.compactMap { representableData[$0] }
//        self.rawData = rawData
        
        self.sortedRepresentableKeys = sortedRepresentableKeys
        self.valuesSortedByKeys = valuesSortedByKeys
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
