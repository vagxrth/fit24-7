//
//  MonthlyWorkoutViews.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 18/02/25.
//

import SwiftUI

struct MonthlyWorkoutViews: View {
    
    @StateObject var viewModel = MonthlyWorkoutsViewModel()
    
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
                        .foregroundColor(.blue)
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
                        .foregroundColor(.blue)
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
        .padding(.vertical)
        .onChange(of: viewModel.selectedMonth) { _, _ in
            viewModel.updateSelectedDate()
        }
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button(role: .cancel) {
                viewModel.showAlert = false
            } label: {
                Text("Ok")
            }
        } message: {
            Text("Unable To Load Workouts For \(viewModel.selectedDate.monthAndYearFormat()).")
        }
    }
}

#Preview {
    MonthlyWorkoutViews()
}
