//
//  Fit24_7App.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 07/02/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct Fit24_7App: App {
    
    init() {
        
        NotificationManager.shared.requestNotificationPermission()
        
        NotificationManager.shared.scheduleWorkoutReminders()
        NotificationManager.shared.scheduleAffirmationNotifications()
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            FitTabView()
                .onAppear {
                    simulateHeartRateCheck()
                }
        }
    }
    
    func simulateHeartRateCheck() {
        let exampleHeartRate: Int = 125
        HealthManager.shared.checkHeartRate(Double(exampleHeartRate))
    }
}
