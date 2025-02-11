//
//  TermsView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 11/02/25.
//

import SwiftUI

struct TermsView: View {
    
    @State var name = ""
    @AppStorage("username") var username: String?
    @State var acceptedTerms = false
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            TextField("Username", text: $name)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            
            HStack {
                Button {
                    withAnimation {
                        acceptedTerms.toggle()
                    }
                } label: {
                    if acceptedTerms {
                        Image(systemName: "square.inset.filled")
                    } else {
                        Image(systemName: "square")
                    }
                }
                
                Text("Accept Terms & Conditions")
                
            }
            
            Spacer()
            
            Button {
                if acceptedTerms && name.count > 2 {
                    username = name
                }
            } label: {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                    )
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    TermsView()
}
