//
//  HomeView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("Welcome to Fit24-7")
                    .font(.largeTitle)
                    .padding()
                HStack {
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
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
