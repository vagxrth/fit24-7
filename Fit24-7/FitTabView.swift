//
//  TabView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct FitTabView: View {
    
    @StateObject private var tabState = FitnessTabState()
    
    var body: some View {
        TabView(selection: $tabState.selectedTab) {
            HomeView()
                .tag(FitnessTabs.home)
                .tabItem {
                    Image(systemName: "house")
                    Text(FitnessTabs.home.rawValue)
                }
            ChartsView()
                .tag(FitnessTabs.charts)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text(FitnessTabs.charts.rawValue)
                }
            LeaderboardView()
                .tag(FitnessTabs.leaderboard)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(FitnessTabs.leaderboard.rawValue)
                }
            ProfileView()
                .tag(FitnessTabs.profile)
                .tabItem {
                    Image(systemName: "person")
                    Text(FitnessTabs.profile.rawValue)
                }
        }
        .environmentObject(tabState)
        .task {
            do {
                try await HealthManager.shared.requestHealthKitAccess()
            } catch {
                DispatchQueue.main.async {
                    presentAlert(title: "Oops", message: "Unable To Access Health Data!")
                }
            }
        }
    }
}

#Preview {
    FitTabView()
}
