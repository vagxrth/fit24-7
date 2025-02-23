//
//  HomeView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var tabState: FitnessTabState
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    HStack {
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            MetricView(title: "Calories", value: viewModel.calories, color: .red)
                            MetricView(title: "Active", value: viewModel.exercise, color: .green)
                            MetricView(title: "Stand", value: viewModel.stand, color: .blue)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: viewModel.caloriesGoal, color: .red)
                            ProgressCircleView(progress: $viewModel.exercise, goal: viewModel.activeGoal, color: .green)
                                .padding(.all, 20)
                            ProgressCircleView(progress: $viewModel.stand, goal: viewModel.standGoal, color: .blue)
                                .padding(40)
                        }
                        .padding(.horizontal)
                        Spacer()
                    }
                    .padding()
                    
                        Text("Fitness Activity")
                            .font(.title2)
                            .padding(.horizontal)
                    
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            if let caloriesActivity = viewModel.activities.first(where: { $0.title == "Calories Burned" }) {
                                ActivityCardView(activity: caloriesActivity)
                            }
                            
                            if let sleepActivity = viewModel.activities.first(where: { $0.title == "Sleep" }) {
                                ActivityCardView(activity: sleepActivity)
                            }
                            
                            if let heartRateActivity = viewModel.activities.first(where: { $0.title == "Heart Rate" }) {
                                ActivityCardView(activity: heartRateActivity)
                            }
                            
                            ForEach(viewModel.activities.filter {
                                $0.title != "Calories Burned" &&
                                $0.title != "Sleep" &&
                                $0.title != "Heart Rate"
                            }, id: \.title) { activity in
                                ActivityCardView(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle(FitnessTabs.home.rawValue)
            }
        }
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button("Ok") {
                viewModel.showAlert = false
            }
        } message: {
            Text("Error Fetching Data!")
        }
        .onAppear {
            viewModel.fetchGoalData()
        }
    }
}

// MARK: - Helper Views

struct MetricView: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.callout)
                .bold()
                .foregroundColor(color)
            Text("\(value)")
                .bold()
        }
        .padding(.bottom)
    }
}

#Preview {
    HomeView()
        .environmentObject(FitnessTabState())
}
