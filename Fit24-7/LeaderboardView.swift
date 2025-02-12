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
    
    @Published var leaders = [LeaderboardUser]()
    
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
    
    init() {
        Task {
            do {
                try await postStepCountUpdateForUser(username: "kevin", count: 1876)
                let result = try await fetchLeaderboard()
                DispatchQueue.main.async {
                    self.leaders = result.top10
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    func fetchLeaderboard() async throws -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboard()
        let top10 = Array(leaders.sorted(by: {
            $0.count > $1.count
        }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username {
            let user = leaders.first(where: {
                $0.username == username
            })
            return LeaderboardResult(user: user, top10: top10)

        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    func postStepCountUpdateForUser(username: String, count: Int) async throws {
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: count))
    }
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
                ForEach(viewModel.leaders) {
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
//        .task {
//            do {
//                try await DatabaseManager.shared.fetchLeaderboard()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
