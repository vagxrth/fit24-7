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
    
    @MainActor
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        let sleep = HKCategoryType(.sleepAnalysis) // Add sleep
        let heartRate = HKQuantityType(.heartRate) // Add heart rate

        let healthTypes: Set = [calories, exercise, stand, steps, workouts, sleep, heartRate]
        try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
    }
    
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
                
            let calorieCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(calorieCount))
        }
            
        healthStore.execute(query)
    }
    
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
