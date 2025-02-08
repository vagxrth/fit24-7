//
//  HomeViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    var mockActivityData = [
        Activity(id: 0, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .green, data: "6,121"),
        Activity(id: 1, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .red, data: "812"),
        Activity(id: 2, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.walk", tintColor: .blue, data: "6,121"),
        Activity(id: 3, title: "Today Steps", subtitle: "Goal 10,000", image: "figure.run", tintColor: .purple, data: "12,121")
    ]
    
    var mockWorkoutData = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .green, duration: "23 mins", date: "Aug 3rd", calories: "341 Kcal"),
        Workout(id: 1, title: "Swimming", image: "figure.run", tintColor: .cyan, duration: "15 mins", date: "Aug 5th", calories: "341 Kcal"),
        Workout(id: 2, title: "Treadmill", image: "figure.run", tintColor: .brown, duration: "20 mins", date: "Aug 8th", calories: "341 Kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .pink, duration: "11 mins", date: "Aug 10th", calories: "341 Kcal")
    ]
    
    @State var calories: Int = 123
    @State var active: Int = 52
    @State var standing: Int = 4
}
