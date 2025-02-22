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
    
    func checkHeartRate(_ heartRate: Double) {
        let lowerBound = 50.0
        let upperBound = 120.0
        
        if heartRate < lowerBound || heartRate > upperBound {
            let condition = heartRate < lowerBound ? "too low (\(heartRate) BPM)" : "too high (\(heartRate) BPM)"
            NotificationManager.shared.notifyHealthRisk(for: "an abnormal heart rate: \(condition).")
        }
    }
    
    func fetchLatestHeartRate() async throws -> Double {
        let heartRateType = HKQuantityType(.heartRate)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { _, results, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let sample = results?.first as? HKQuantitySample else {
                    continuation.resume(returning: 0.0)
                    return
                }
                
                let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
                
                // Check for abnormal heart rate and trigger a notification if needed
                self.checkHeartRate(heartRate)
                
                continuation.resume(returning: heartRate)
            }
            self.healthStore.execute(query)
        }
    }
    
    private func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int) -> [Activity] {
        return [
            Activity(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
            Activity(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .blue, amount: "\(strength) mins"),
            Activity(title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .indigo, amount: "\(soccer) mins"),
            Activity(title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .green, amount: "\(basketball) mins"),
            Activity(title: "Stairstepper", subtitle: "This week", image: "figure.stairs", tintColor: .green, amount: "\(stairs) mins"),
            Activity(title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(kickboxing) mins"),
        ]
    }
    
    func fetchCurrentWeekWorkoutStats(completion: @escaping (Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Only tracking acitivties we are interested in
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration)/60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            
            completion(.success(self.generateActivitiesFromDurations(running: runningCount, strength: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
        }
        healthStore.execute(query)
    }
    
    func fetchCurrentWeekActivities() async throws -> [Activity] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchCurrentWeekWorkoutStats { result in
                continuation.resume(with: result)
            }
        })
    }
    
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Generates workout cards that will be displayed on home screen
            let workoutsArray = workouts.map( { Workout(title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate, calories: ($0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") + " kcal") })
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
    
    func fetchRecentWorkouts() async throws -> [Workout] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchWorkoutsForMonth(month: .now) { result in
                continuation.resume(with: result)
            }
        })
    }
}

// MARK: Charts View

extension HealthManager {
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(quantityType: steps, quantitySamplePredicate: nil, anchorDate: startDate, intervalComponents: interval)
        
        // Method to query health data for each date of a given period
        query.initialResultsHandler = { _, results, error in
            guard let result = results, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var dailySteps = [DailyStepModel]()
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailySteps.append(DailyStepModel(date: statistics.startDate, count: Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
            }
            completion(.success(dailySteps))
        }
        healthStore.execute(query)
    }
    
    func fetchOneWeekStepData() async throws -> [DailyStepModel] {
        try await withCheckedThrowingContinuation({ continuation in
            fetchDailySteps(startDate: .oneWeekAgo) { result in
                switch result {
                case .success(let steps):
                    continuation.resume(returning: steps)
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        })
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
