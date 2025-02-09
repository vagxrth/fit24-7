//
//  MonthlyStepModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 09/02/25.
//

import Foundation

struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
