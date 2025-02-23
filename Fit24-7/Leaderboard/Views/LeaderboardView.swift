//
//  LeaderboardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 10/02/25.
//

import SwiftUI

struct LeaderboardView: View {
    
    @EnvironmentObject var tabState: FitnessTabState
    @StateObject var viewModel = LeaderboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
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
                                if idx == 0 {
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
                        .padding(.horizontal)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                if tabState.showTerms {                    
                    TermsView()
                        .environmentObject(viewModel)
                        .environmentObject(tabState)
                }
            }
            .navigationTitle(FitnessTabs.leaderboard.rawValue)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.didCompleteAccepting || viewModel.username != nil {
                        Button {
                            Task {
                                do {
                                    try await viewModel.setupLeaderboardData()
                                } catch {
                                    viewModel.showAlert = true
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Color(uiColor: .label))
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .alert("Oops", isPresented: $viewModel.showAlert, actions: {
                Button(role: .cancel) {
                    viewModel.showAlert = false
                } label: {
                    Text("Ok")
                }
            }, message: {
                Text("Error Loading Leaderboard!")
            })
            .onChange(of: tabState.showTerms) { _, _ in
                if !tabState.showTerms && viewModel.username != nil {
                    Task {
                        do {
                            try await viewModel.setupLeaderboardData()
                        } catch {
                            viewModel.showAlert = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LeaderboardView()
        .environmentObject(FitnessTabState())
}
