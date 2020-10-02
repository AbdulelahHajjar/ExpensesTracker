//
//  NewDashboardViewModel.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 01/10/2020.
//  Copyright © 2020 Abdulelah Hajjar. All rights reserved.
//

import Foundation
import Combine

final class NewDashboardViewModel: ObservableObject {
    @Published private(set) var displayName: String? = nil
    @Published private(set) var todaysSpendings: Double? = nil
    @Published private(set) var budgetInsightsChartViewModel: BudgetInsightsChartViewModel? = nil
    @Published private(set) var today = Date()
    
    @Published private var dashboardBudget: Budget? = nil
    @Published private var appStateRepository = AppStateRepository.shared
    @Published private var userDataRepository = UserDataRepository.shared
    @Published private var budgetsRepository = BudgetsRepository.shared
    @Published private var expensesRepository = ExpensesRepository.shared
    
    private var cancellables = Set<AnyCancellable>()

    init() { registerSubscribers() }
    
    private func registerSubscribers() {
        appStateRepository.$today
            .map { $0 }
            .assign(to: \.today, on: self)
            .store(in: &cancellables)
        
        userDataRepository.$userData
            .receive(on: DispatchQueue.main)
            .map { $0?.firstName }
            .assign(to: \.displayName, on: self)
            .store(in: &cancellables)
        
        budgetsRepository.$dashboardBudget
            .receive(on: DispatchQueue.main)
            .assign(to: \.dashboardBudget, on: self)
            .store(in: &cancellables)
        
        $dashboardBudget
            .receive(on: DispatchQueue.main)
            .map { $0?.insights.spendingsInDay(of: self.appStateRepository.today) }
            .assign(to: \.todaysSpendings, on: self)
            .store(in: &cancellables)
        
        $dashboardBudget
            .receive(on: DispatchQueue.main)
            .map {
                guard let budget = $0 else { return nil }
                return BudgetInsightsChartViewModel(dailySpendings: budget.insights.dailySpendings,
                                                    currentChartDate: self.today.byAddingDays(-7),
                                                    minimumDate: budget.startDate,
                                                    maximumDate: budget.endDate)
            }
            .assign(to: \.budgetInsightsChartViewModel, on: self)
            .store(in: &cancellables)
    }
}
