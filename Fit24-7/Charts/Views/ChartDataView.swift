//
//  ChartDataView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 09/02/25.
//

import SwiftUI

struct ChartDataView: View {
    
    @Binding var average: Int
    @Binding var total: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Average")
                    .font(.title2)
                    .minimumScaleFactor(0.6)
                Text("\(average)")
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            VStack(spacing: 16) {
                Text("Total")
                    .font(.title2)
                    .minimumScaleFactor(0.6)
                Text("\(total)")
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(.primary)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
    }
}

#Preview {
    ChartDataView(average: .constant(1235), total: .constant(8461))
}
