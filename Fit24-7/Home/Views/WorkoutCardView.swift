//
//  WorkoutCardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct WorkoutCardView: View {
    
    var workout: Workout
    
    var body: some View {
        HStack {
            Image(systemName: workout.image)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .foregroundColor(workout.tintColor)
                .padding()
                .background(.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(spacing: 16) {
                HStack {
                    Text(workout.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .font(.title3)
                        .bold()
                    Spacer()
                    Text(workout.duration)
                }
                HStack {
                    Text(workout.date.formatWorkoutDate())
                    Spacer()
                    Text(workout.calories)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WorkoutCardView(workout: Workout(title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: Date(), calories: "512 kcal"))
}
