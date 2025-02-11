//
//  LeaderboardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 10/02/25.
//

import SwiftUI

struct LeaderboardUser: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    var mockData = [
        LeaderboardUser(id: 0, createdAt: "", username: "john", count: 2122),
        LeaderboardUser(id: 1, createdAt: "", username: "seth", count: 4332),
        LeaderboardUser(id: 2, createdAt: "", username: "drew", count: 3711),
        LeaderboardUser(id: 3, createdAt: "", username: "mark", count: 6134),
        LeaderboardUser(id: 4, createdAt: "", username: "pat", count: 1123),
        LeaderboardUser(id: 5, createdAt: "", username: "paul", count: 2122),
        LeaderboardUser(id: 6, createdAt: "", username: "sam", count: 4332),
        LeaderboardUser(id: 7, createdAt: "", username: "elon", count: 3711),
        LeaderboardUser(id: 8, createdAt: "", username: "garry", count: 6134),
        LeaderboardUser(id: 9, createdAt: "", username: "peter", count: 1123)
    ]
}

struct LeaderboardView: View {
    
    @State var viewModel = LeaderboardViewModel()
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text("Name")
                    .bold()
                
                Spacer()
                
                Text("Steps")
                    .bold()
            }
            .padding()
            
            LazyVStack(spacing: 24) {
                ForEach(viewModel.mockData) {
                    person in HStack {
                        Text("\(person.id).")
                        Text(person.username)
                        Spacer()
                        Text("\(person.count)")
                    }
                    .padding(.horizontal)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LeaderboardView()
}
