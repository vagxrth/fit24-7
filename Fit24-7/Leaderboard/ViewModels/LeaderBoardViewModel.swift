//
//  LeaderBoardViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 12/02/25.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    
    @Published var leaderResult = LeaderboardResult(user: nil, top10: [])
    @Published var showAlert = false

    
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
    
    enum LeaderboardViewModelError: Error {
        case unableToFetchUsername
    }
    
    init() {
        setupLeaderboardData()
    }
    
    func setupLeaderboardData() {
        Task {
            do {
                try await postStepCountUpdateForUser(username: "kevin")
                let result = try await fetchLeaderboard()
                DispatchQueue.main.async {
                    self.leaderResult = result
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    private func fetchLeaderboard() async throws -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboard()
        let top10 = Array(leaders.sorted(by: {
            $0.count > $1.count
        }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: {
            $0.username == username
        }) {
            let user = leaders.first(where: {
                $0.username == username
            })
            return LeaderboardResult(user: user, top10: top10)

        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    private func postStepCountUpdateForUser(username: String) async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw LeaderboardViewModelError.unableToFetchUsername
        }
        let steps = try await fetchCurrentWeekStepCount()
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: Int(steps)))
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({
            continuation in HealthManager.shared.fetchCurrentWeekStepCount {
                result in continuation.resume(with: result)
            }
        })
    }
}
