//
//  TabState.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 23/02/25.
//

import Foundation

enum FitnessTabs: String, CaseIterable {
    case home = "Home"
    case charts = "Charts"
    case leaderboard = "Leaderboard"
    case profile = "Profile"
    case plans = "Plans"
}

final class FitnessTabState: ObservableObject {
    @Published var selectedTab: FitnessTabs = .home
    @Published var showTerms = true
    
    init(selectedTab: FitnessTabs = .home, showTerms: Bool = true) {
        self.selectedTab = selectedTab
        self.showTerms = UserDefaults.standard.string(forKey: "username") == nil
    }
}
