//
//  DatabaseManager.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 11/02/25.
//

import Foundation
import FirebaseFirestore

protocol DatabaseManagerType {
    func fetchLeaderboard() async throws -> [LeaderboardUser]
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws
}

final class DatabaseManager: DatabaseManagerType {
    static let shared = DatabaseManager()
    
    private init() {
        
    }
    
    private let database = Firestore.firestore()
    private let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    func fetchLeaderboard() async throws -> [LeaderboardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({
            try $0.data(as: LeaderboardUser.self)
        })
    }
    
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
}
