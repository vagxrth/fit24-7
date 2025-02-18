//
//  MonthlyWorkoutViews.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 18/02/25.
//

import SwiftUI

class MonthlyWorkoutViewModel: ObservableObject {
    
    @Published var selectedMonth = 0
    @Published var selectedDate = Date()
    
    @Published var workouts = [Workout]()
    @Published var currentMonthWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .green, duration: "23 mins", date: "Aug 3rd", calories: "341 Kcal"),
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .green, duration: "23 mins", date: "Aug 3rd", calories: "341 Kcal"),
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .green, duration: "23 mins", date: "Aug 3rd", calories: "341 Kcal")
    ]
    
    func updateSelectedMonth() {
        self.selectedDate = Calendar.current.date(byAdding: .month, value: selectedMonth, to: Date()) ?? Date()
    }
    
}

struct MonthlyWorkoutViews: View {
    
    @StateObject var viewModel = MonthlyWorkoutViewModel()
    
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.selectedMonth -= 1
                    }
                } label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                
                Spacer()
                
                Text(viewModel.selectedDate.monthAndYearFormat())
                    .font(.title)
                    .frame(maxWidth: 250)
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.selectedMonth += 1
                    }
                } label: {
                    Image(systemName: "arrow.forward.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .opacity(viewModel.selectedMonth >= 0 ? 0.5 : 1)
                }
                .disabled(viewModel.selectedMonth >= 0)
                
                Spacer()
                
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.currentMonthWorkouts, id: \.self) { workout in
                    WorkoutCardView(workout: workout)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .onChange(of: viewModel.selectedMonth) {
            _ in viewModel.updateSelectedMonth()
        }
    }
}

#Preview {
    MonthlyWorkoutViews()
}
