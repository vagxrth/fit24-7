//
//  HomeView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct HomeView: View {
    
    @State var calories: Int = 123
    @State var active: Int = 52
    @State var standing: Int = 4
    
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
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Welcome to Fit24-7")
                        .font(.largeTitle)
                        .padding()
                    HStack {
                        
                        Spacer()
                        
                        VStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                Text("123 Kcal")
                                    .bold()
                            }
                            .padding(.bottom)
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                Text("52 mins")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Standing")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.blue)
                                Text("4 hours")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $calories, goal: 500, color: .red)
                            ProgressCircleView(progress: $active, goal: 120, color: .green)
                                .padding(.all, 20)
                            ProgressCircleView(progress: $standing, goal: 5, color: .blue)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer ()
                        
                        Button {
                            print("Show More")
                        } label: {
                            Text("Show More")
                                .padding(.all, 10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(mockActivityData, id: \.id) {
                            activity in ActivityCardView(activity: activity)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Recent Workouts")
                            .font(.title2)
                        
                        Spacer ()
                        
                        NavigationLink {
                            EmptyView()
                        } label: {
                            Text("Show More")
                                .padding(.all, 10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(mockWorkoutData, id: \.id) {
                            workout in WorkoutCardView(workout: workout)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
