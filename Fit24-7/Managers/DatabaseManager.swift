//
//  DatabaseManager.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 11/02/25.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {
        
    }
    
    let database = Firestore.firestore()
    
    func fetchLeaderboard() async throws {
        let snapshot = try await database.collection("users").getDocuments()
        
        print(snapshot.documents)
        print(snapshot.documents.first?.data())
    }
}
