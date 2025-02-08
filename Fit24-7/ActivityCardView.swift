//
//  ActivityCardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct ActivityCardView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Today Steps")
                        Text("Goal 10,000")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "figure.walk")
                        .foregroundColor(.green)
                }
                Text("6,121 Steps")
                    .font(.title)
                    .bold()
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCardView()
}
