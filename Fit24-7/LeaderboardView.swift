//
//  LeaderboardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 10/02/25.
//

import SwiftUI

struct LeaderboardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    var mockData = [
        LeaderboardUser(username: "john", count: 2122),
        LeaderboardUser(username: "seth", count: 4332),
        LeaderboardUser(username: "drew", count: 3711),
        LeaderboardUser(username: "mark", count: 6134),
        LeaderboardUser(username: "pat", count: 1123),
        LeaderboardUser(username: "paul", count: 2122),
        LeaderboardUser(username: "sam", count: 4332),
        LeaderboardUser(username: "elon", count: 3711),
        LeaderboardUser(username: "garry", count: 6134),
        LeaderboardUser(username: "peter", count: 1123)
    ]
}

struct LeaderboardView: View {
    
    @State var viewModel = LeaderboardViewModel()
    @Binding var showTerms: Bool
    
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
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
        .task {
            do {
                try await DatabaseManager.shared.fetchLeaderboard()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
