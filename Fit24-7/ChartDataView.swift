//
//  ChartDataView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 09/02/25.
//

import SwiftUI

struct ChartDataView: View {
    
    @State var average: Int
    @State var total: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Average")
                    .font(.title2)
                Text("\(average)")
                    .font(.title3)
            }
            .frame(width: 90)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Total")
                    .font(.title2)
                Text("\(total)")
                    .font(.title3)
            }
            .frame(width: 90)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
    }
}

#Preview {
    ChartDataView(average: 383, total: 2385)
}
