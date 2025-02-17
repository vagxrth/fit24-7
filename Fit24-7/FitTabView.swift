//
//  TabView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct FitTabView: View {
    @State var selectedTab = "Home"
    @AppStorage("username") var username: String?
    @State var showTerms = true

    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home")
                .tabItem{
                    Image(systemName: "house")
                }
            ChartsView()
                .tag("Charts")
                .tabItem{
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
            LeaderboardView(showTerms: $showTerms)
                .tag("Leaderboard")
                .tabItem{
                    Image(systemName: "list.clipboard")
                }
            ProfileView()
                .tag("Profile")
                .tabItem{
                    Image(systemName: "person")
                }
        }
        .onAppear {
            showTerms = username == nil
        }
    }
}

#Preview {
    FitTabView()
}
