//
//  ProfileViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 16/02/25.
//

import Foundation
import SwiftUI

@Observable
final class ProfileViewModel: ObservableObject {
    
    var isEditingName = false
    var currentName = ""
    var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    
    var isEditingImage = false
    var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    
    var showAlert = false
    
    var images = ["bench", "machine", "press", "rowing", "weight"]
    
    var presentGoal = false
    var caloriesGoal: Int = UserDefaults.standard.value(forKey: "caloriesGoal") as? Int ?? 900
    var stepGoal: Int = UserDefaults.standard.value(forKey: "stepGoal") as? Int ?? 7500
    var activeGoal: Int = UserDefaults.standard.value(forKey: "activeGoal") as? Int ?? 60
    var standGoal: Int = UserDefaults.standard.value(forKey: "standGoal") as? Int ?? 12
    var sleepGoal: Int = UserDefaults.standard.value(forKey: "sleepGoal") as? Int ?? 8
    var weightGoal: Double = UserDefaults.standard.value(forKey: "weightGoal") as? Double ?? 70.0
    
    var notificationsEnabled: Bool = UserDefaults.standard.bool(forKey: "notificationsEnabled") {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
            handleNotificationToggle()
        }
    }
    
    var isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn") {
        didSet {
            UserDefaults.standard.set(isUserLoggedIn, forKey: "isUserLoggedIn")
        }
    }
    
    func presentEditName() {
        isEditingName = true
        isEditingImage = false
    }
    
    func presentEditImage() {
        isEditingName = false
        isEditingImage = true
    }
    
    func dismissEdit() {
        isEditingName = false
        isEditingImage = false
    }
    
    func editName() {
        if !currentName.isEmpty {
            profileName = currentName
            UserDefaults.standard.setValue(currentName, forKey: "profileName")
            self.dismissEdit()
        }
    }
    
    func selectNewImage(name: String) {
        selectedImage = name
    }
    
    func editImage() {
        profileImage = selectedImage
        UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
        self.dismissEdit()
    }
    
    @MainActor
    func presentEmailApp() {
        let emailSubject = "Contact Fit24-7"
        let emailRecipient = "vagarth419@gmail.com"
        
        let encodedSubject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedRecipient = emailRecipient.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let urlString = "mailto:\(encodedRecipient)?subject=\(encodedSubject)"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.showAlert = true
            }
        }
    }
    
    func saveUserGoals() {
        UserDefaults.standard.set(stepGoal, forKey: "stepGoal")
        UserDefaults.standard.set(caloriesGoal, forKey: "caloriesGoal")
        UserDefaults.standard.set(activeGoal, forKey: "activeGoal")
        UserDefaults.standard.set(standGoal, forKey: "standGoal")
        UserDefaults.standard.set(sleepGoal, forKey: "sleepGoal")
        UserDefaults.standard.set(weightGoal, forKey: "weightGoal")
        presentGoal = false
    }
    
    private func handleNotificationToggle() {
        if notificationsEnabled {
            NotificationManager.shared.scheduleWorkoutReminders()
            NotificationManager.shared.scheduleAffirmationNotifications()
        } else {
            NotificationManager.shared.disableAllNotifications()
        }
    }
    
    func loginUser(email: String, password: String) {
        // Replace with actual login logic (e.g., Firebase Auth)
        if email == "vagarth@fit247.com" && password == "password" {
            isUserLoggedIn = true
        } else {
            // Handle login failure
            isUserLoggedIn = false
        }
    }
    
    func logoutUser() {
        isUserLoggedIn = false
    }
    
    func registerUser(email: String, password: String) {
        // Replace with actual registration logic (e.g., Firebase Auth)
        isUserLoggedIn = true
    }
}
