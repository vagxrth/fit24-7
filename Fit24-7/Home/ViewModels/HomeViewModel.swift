//
//  HomeViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

enum HealthError: Error {
    case authorizationDenied
    case dataFetchError
    case unavailable
}

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var showAllActivities = false
    @Published var showAlert = false
    @Published var errorMessage = ""
    
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int = 0
    @Published var sleepHours: Double = 0.0
    @Published var heartRate: Double = 0.0
    
    @Published var stepGoal: Int
    @Published var caloriesGoal: Int
    @Published var activeGoal: Int
    @Published var standGoal: Int
    
    @Published var activities: [Activity] = []
    @Published var workouts: [Workout] = []
    
    
    private let healthManager: HealthManagerType
    
    init(healthManager: HealthManagerType = HealthManager.shared) {
        self.healthManager = healthManager
        
        // Initialize goals from UserDefaults
        self.stepGoal = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
        self.caloriesGoal = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
        self.activeGoal = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
        self.standGoal = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
        
        // Start data fetch
        Task {
            await setupHealthKit()
        }
    }
    
    private func setupHealthKit() async {
        do {
            try await healthManager.requestHealthKitAccess()
            try await fetchHealthData()
        } catch let error as HealthError {
            switch error {
            case .authorizationDenied:
                errorMessage = "Please enable Health access in Settings to view your fitness data."
            case .dataFetchError:
                errorMessage = "Unable to fetch your fitness data. Please try again."
            case .unavailable:
                errorMessage = "HealthKit is not available on this device."
            }
            showAlert = true
        } catch {
            errorMessage = "An unexpected error occurred. Please try again."
            showAlert = true
        }
    }
    
    func fetchHealthData() async throws {
        async let fetchCalories: () = try await fetchTodayCalories()
        async let fetchExercise: () = try await fetchTodayExerciseTime()
        async let fetchStand: () = try await fetchTodayStandHours()
        async let fetchSteps: () = try await fetchTodaySteps()
        async let fetchActivities: () = try await fetchCurrentWeekActivities()
        async let fetchWorkouts: () = try await fetchRecentWorkouts()
        async let fetchSleep: () = try await fetchTodaySleep()
        async let fetchHeartRate: () = try await fetchTodayHeartRate()
        
        let (_, _, _, _, _, _, _, _) = (
            try await fetchCalories,
            try await fetchExercise,
            try await fetchStand,
            try await fetchSteps,
            try await fetchActivities,
            try await fetchWorkouts,
            try await fetchSleep,
            try await fetchHeartRate
        )
    }
    
    func fetchGoalData() {
        stepGoal = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
        caloriesGoal = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
        activeGoal = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
        standGoal = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    }
    
    func fetchTodayCalories() async throws {
        do {
            calories = Int(try await healthManager.fetchTodayCalories())
            let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "\(calories)")
            activities.append(activity)
        } catch {
            let activity = Activity(title: "Calories Burned", subtitle: "today", image: "flame", tintColor: .red, amount: "---")
            activities.append(activity)
        }
    }
    
    func fetchTodayExerciseTime() async throws {
        exercise = Int(try await healthManager.fetchTodayExerciseTime())
    }
    
    func fetchTodayStandHours() async throws {
        stand = try await healthManager.fetchTodayStandHours()
    }
    
    func fetchTodaySteps() async throws {
        let activity = try await healthManager.fetchTodaySteps()
        activities.insert(activity, at: 0)
    }
    
    func fetchCurrentWeekActivities() async throws {
        let weekActivities = try await healthManager.fetchCurrentWeekActivities()
        activities.append(contentsOf: weekActivities)
    }
    
    func fetchRecentWorkouts() async throws {
        let monthWorkouts = try await healthManager.fetchRecentWorkouts()
        // Only displays the most recent 4 (four) workouts, the rest are behind a paywall
        workouts = Array(monthWorkouts.prefix(4))
    }
    
    func fetchTodaySleep() async throws {
        do {
            sleepHours = try await healthManager.fetchTodaySleepHours()
            let activity = Activity(title: "Sleep", subtitle: "Today", image: "bed.double", tintColor: .purple, amount: "\(sleepHours.formatted(.number.precision(.fractionLength(1)))) hrs")
            activities.append(activity)
        } catch {
            let activity = Activity(title: "Sleep", subtitle: "Today", image: "bed.double", tintColor: .purple, amount: "---")
            activities.append(activity)
        }
    }
    
    func fetchTodayHeartRate() async throws {
        do {
            heartRate = try await healthManager.fetchLatestHeartRate()
            let activity = Activity(title: "Heart Rate", subtitle: "Today", image: "heart.fill", tintColor: .red, amount: "\(Int(heartRate)) bpm")
            activities.append(activity)
        } catch {
            let activity = Activity(title: "Heart Rate", subtitle: "Today", image: "heart.fill", tintColor: .red, amount: "---")
            activities.append(activity)
        }
    }
}
