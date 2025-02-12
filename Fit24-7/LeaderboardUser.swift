//
//  LeaderboardUser.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 12/02/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    var id = UUID()
    let username: String
    let count: Int
}
