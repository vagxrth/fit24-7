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
    
    func fetchTodayCaloriesBurnt(completion: @escaping(Result<Double, Error>) -> Void) {
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
    
    func fetchTodayCalories() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayCaloriesBurnt { result in
                switch result {
                case .success(let calories):
                    continuation.resume(returning: calories)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
    }
    
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
                
            let exerciseTime = quantity.doubleValue(for: .minute())
            completion(.success(exerciseTime))
        }
            
        healthStore.execute(query)
    }
    
    func fetchTodayExerciseTime() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayExerciseTime { result in
                continuation.resume(with: result)
            }
        })
    }
    
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(error!))
                return
            }
                
            let standCount = samples.filter({ $0.value == 0 }).count
            completion(.success(standCount))
        }
            
        healthStore.execute(query)
    }
    
    func fetchTodayStandHours() async throws -> Int {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodayStandHours { result in
                continuation.resume(with: result)
            }
        })
    }
    
    func fetchTodaySteps(completion: @escaping(Result<Activity, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.success(Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor:.green, amount: "---")))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            let stepsGoal = UserDefaults.standard.value(forKey: "stepsGoal") ?? 7500
            let activity = Activity(title: "Today Steps", subtitle: "Goal: \(stepsGoal)", image: "figure.walk", tintColor: .green, amount: steps.formattedNumberString())
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodaySteps() async throws -> Activity {
        try await withCheckedThrowingContinuation({ continuation in
            fetchTodaySteps { result in
                continuation.resume(with: result)
            }
        })
    }
    
    func fetchTodaySleepHours() async throws -> Double {
        let sleepType = HKCategoryType(.sleepAnalysis)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = results as? [HKCategorySample] else {
                    continuation.resume(returning: 0.0)
                    return
                }
                
                // Calculate total sleep time in hours
                let totalSleep = samples.reduce(0.0) { total, sample in
                    total + sample.endDate.timeIntervalSince(sample.startDate)
                }
                
                continuation.resume(returning: totalSleep / 3600.0) // Convert seconds to hours
            }
            self.healthStore.execute(query)
        }
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
