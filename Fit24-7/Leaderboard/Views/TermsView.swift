//
//  TermsView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 11/02/25.
//

import SwiftUI

struct TermsView: View {
    
    @EnvironmentObject var tabState: FitnessTabState
    @EnvironmentObject var viewModel: LeaderboardViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                TextField("Username", text: $viewModel.termsViewUsername)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            viewModel.acceptedTerms.toggle()
                        }
                    } label: {
                        Image(systemName: viewModel.acceptedTerms ? "square.inset.filled" : "square")
                    }
                    Text("By checking you agree to the Terms and Enter into the Leaderboard Competition.")

                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.acceptedTermsAndSignedUp()
                    }
                } label: {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .navigationTitle("Leaderboard")
            .onChange(of: viewModel.didCompleteAccepting) { _, newValue in
                if newValue {
                    tabState.showTerms = false
                }
            }
        }
    }
}

#Preview {
    TermsView()
        .environmentObject(FitnessTabState())
        .environmentObject(LeaderboardViewModel())
}
