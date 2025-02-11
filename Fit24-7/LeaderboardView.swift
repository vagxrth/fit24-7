//
//  LeaderboardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 10/02/25.
//

import SwiftUI

struct LeaderboardUser: Codable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    
}

struct LeaderboardView: View {
    var body: some View {
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
            
            LazyVStack {
                ForEach(<#T##data: Range<Int>##Range<Int>#>, content: <#T##(Int) -> View#>)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    LeaderboardView()
}
