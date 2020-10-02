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
    @Published private(set) var sortedRepresentableKeys : [String] = []
    @Published private(set) var valuesSortedByKeys      : [Double] = []
    @Published private(set) var currentChartDate        : Date
    var endDate                                         : Date {
        let endDate = currentChartDate.byAddingDays(7)
        return endDate < maximumDate ? endDate : maximumDate
    }
    
    @Published private var dailySpendings               : [Date : Double]
    @Published private var sortedFilteredDates          : [Date] = []
    private var cancellables                            = Set<AnyCancellable>()
    
    private(set) var minimumDate: Date
    private(set) var maximumDate: Date
    
    init(dailySpendings: [Date : Double], currentChartDate: Date, minimumDate: Date, maximumDate: Date) {
        if currentChartDate < minimumDate {
            self.currentChartDate = minimumDate
        } else if currentChartDate > maximumDate {
            self.currentChartDate = maximumDate
        } else {
            self.currentChartDate = currentChartDate
        }
        self.dailySpendings = dailySpendings
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.sortedFilteredDates = BudgetInsightsChartViewModel.filteredDateArray(x1Date: self.currentChartDate, x2Date: self.endDate, dailySpendings: dailySpendings).sorted()
        print("currentChartDate: \(self.currentChartDate.shortDate), endDate: \(endDate.shortDate)")
        registerSubscribers()
    }
    
    func goToNextPage() {
        let newCurrentChartDate = currentChartDate.byAddingDays(7)
        if newCurrentChartDate > maximumDate.byAddingDays(-7) {
            self.currentChartDate = maximumDate.byAddingDays(-7)
        } else {
            self.currentChartDate = newCurrentChartDate
        }
    }
    
    func goToPreviousPage() {
        let newCurrentChartDate = currentChartDate.byAddingDays(-7)
        if newCurrentChartDate < minimumDate {
            self.currentChartDate = minimumDate
        } else {
            self.currentChartDate = newCurrentChartDate
        }
    }
    
    static private func filteredDateArray(x1Date: Date, x2Date: Date, dailySpendings: [Date : Double]) -> [Date] {
        return Array(dailySpendings.keys).filter { (Calendar.current.isDate($0, inSameDayAs: x1Date) || $0 > x1Date) && (Calendar.current.isDate($0, inSameDayAs: x2Date) || $0 < x2Date) }
    }
    
    private func registerSubscribers() {
        $sortedFilteredDates
            .receive(on: DispatchQueue.main)
            .map { $0.map { $0.shortDate } }
            .assign(to: \.sortedRepresentableKeys, on: self)
            .store(in: &cancellables)
        
        $sortedFilteredDates
            .receive(on: DispatchQueue.main)
            .map { $0.compactMap { self.dailySpendings[$0] } }
            .assign(to: \.valuesSortedByKeys, on: self)
            .store(in: &cancellables)
        
        $currentChartDate
            .receive(on: DispatchQueue.main)
            .sink { currentChartDate in
                self.sortedFilteredDates = BudgetInsightsChartViewModel.filteredDateArray(x1Date: currentChartDate, x2Date: self.endDate, dailySpendings: self.dailySpendings).sorted()
            }
            .store(in: &cancellables)
    }
}
