//
//  ProfileViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 16/02/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var isEditingName = false
    @Published var isEditingImage = false
    @Published var currentName = ""
    @Published var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    @Published var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    @Published var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    
    var images = ["bench", "machine", "press", "rowing", "weight"]
    
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
        profileName = currentName
        UserDefaults.standard.setValue(currentName, forKey: "profileName")
        self.dismissEdit()
    }
    
    func selectNewImage(name: String) {
        selectedImage = name
    }
    
    func editImage() {
        profileImage = selectedImage
        UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
        self.dismissEdit()
    }
}
