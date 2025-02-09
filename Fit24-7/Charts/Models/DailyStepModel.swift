//
//  DailyStepModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 09/02/25.
//

import Foundation

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
