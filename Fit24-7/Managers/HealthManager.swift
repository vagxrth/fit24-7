//
//  HealthManager.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 12/02/25.
//

import Foundation
import HealthKit

class HealthManager {
    
    static let shared = HealthManager()
    private let healthStore = HKHealthStore()
    
}

// MARK: Leaderboard View
extension HealthManager {
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
            let steps = HKQuantityType(.stepCount)
            let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())

            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
                guard let quantity = results?.sumQuantity(), error == nil else {
                    completion(.failure(error!))
                    return
                }
                
                let steps = quantity.doubleValue(for: .count())
                completion(.success(steps))
            }
            
            healthStore.execute(query)
        }
}
