//
//  BudgetsView.swift
//  ExpensesTracker
//
//  Created by Abdulelah Hajjar on 20/03/2021.
//  Copyright © 2021 Abdulelah Hajjar. All rights reserved.
//

import SwiftUI

struct BudgetsView: View {
    @ObservedObject var budgetsRepository = BudgetsRepository.shared
    
    var body: some View {
        List {
            ForEach(budgetsRepository.budgets) { budget in
                Text(budget.name)
            }
        }
    }
}

struct BudgetsView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetsView()
    }
}
