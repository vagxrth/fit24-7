//
//  ProfileView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 13/02/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image("machine")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.4))
                    )
                VStack(alignment: .leading) {
                    Text("Good Morning, ")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("Vagarth")
                        .font(.title)
                }
            }
            
            VStack {
                ProfileButtonView(title: "Edit Name", image: "square.and.pencil") {
                    print("Edit Name")
                }
                
                ProfileButtonView(title: "Edit Image", image: "square.and.pencil") {
                    print("Edit Image")
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    ProfileView()
}
