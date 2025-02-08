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
    
    var body: some View {
        ScrollView {
            VStack {
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
            }
        }
    }
}

#Preview {
    HomeView()
}
