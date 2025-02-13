//
//  LeaderboardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 10/02/25.
//

import SwiftUI

struct LeaderboardView: View {
    
    @AppStorage("username") var username: String?
    @StateObject var viewModel = LeaderboardViewModel()
    @Binding var showTerms: Bool
    
    var body: some View {
        ZStack {
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
                    ForEach(Array(viewModel.leaderResult.top10.enumerated()), id: \.element.id) {
                        ( idx, person ) in HStack {
                            Text("\(idx + 1).")
                            Text(person.username)
                            if username == person.username {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                            Spacer()
                            Text("\(person.count)")
                        }
                        .padding(.horizontal)
                    }
                }
                
                if let user = viewModel.leaderResult.user {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    HStack {
                        Text(user.username)
                        Spacer()
                        Text("\(user.count)")
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if showTerms {
                TermsView(showTerms: $showTerms)
            }
        }
        .onChange(of: showTerms) {
            _ in if !showTerms && username != nil {
                Task {
                    do {
                        try await viewModel.setupLeaderboardData()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
