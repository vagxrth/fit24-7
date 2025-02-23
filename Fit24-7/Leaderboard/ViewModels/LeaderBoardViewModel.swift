//
//  LeaderBoardViewModel.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 12/02/25.
//

import Foundation

@Observable
final class LeaderboardViewModel: ObservableObject {

    var termsViewUsername = ""
    var acceptedTerms = false
    var didCompleteAccepting = false
    
    var username = UserDefaults.standard.string(forKey: "username")
    var leaderResult = LeaderboardResult(user: nil, top10: [])
    var showAlert = false
    
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
    
    var healthManager: HealthManagerType
    var databaseManager: DatabaseManagerType
    
    enum LeaderboardViewModelError: Error {
        case unableToFetchUsername
    }
    
    init(healthManager: HealthManagerType = HealthManager.shared, databaseManager:
         DatabaseManagerType = DatabaseManager.shared) {
        self.healthManager = healthManager
        self.databaseManager = databaseManager
        Task {
            if username != nil {
                do {
                    try await setupLeaderboardData()
                } catch {
                    await MainActor.run {
                        showAlert = true
                    }
                }
            }
        }
    }
    
    func acceptedTermsAndSignedUp() {
        if acceptedTerms && termsViewUsername.count > 2 {
            UserDefaults.standard.set(termsViewUsername, forKey: "username")
            didCompleteAccepting = true
        }
    }
    
    @MainActor
    func setupLeaderboardData() async throws {
        try await postStepCountUpdateForUser()
        let result = try await fetchLeaderboard()
        leaderResult = result
    }
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    private func fetchLeaderboard() async throws -> LeaderboardResult {
        let leaders = try await databaseManager.fetchLeaderboard()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username, !top10.contains(where: { $0.username == username }) {
            let user = leaders.first(where: { $0.username == username })
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    private func postStepCountUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw LeaderboardViewModelError.unableToFetchUsername
        }
        
        // When current week steps throws and error (steps is nil) make step count 0
        let steps = try? await fetchCurrentWeekStepCount()
        try await databaseManager.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: Int(steps ?? 0)))
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({
            continuation in HealthManager.shared.fetchCurrentWeekStepCount {
                result in continuation.resume(with: result)
            }
        })
    }
}
