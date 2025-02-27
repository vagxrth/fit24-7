//
//  ActivityCardView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 08/02/25.
//

import SwiftUI

struct ActivityCardView: View {
    @State var activity: Activity
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(activity.title)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text(activity.subtitle)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: activity.image)
                        .foregroundColor(activity.tintColor)
                }
                Text(activity.amount)
                    .font(.title2)
                    .bold()
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    ActivityCardView(activity: Activity(title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9,812"))
}
