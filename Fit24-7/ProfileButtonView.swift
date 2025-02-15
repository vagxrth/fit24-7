//
//  ProfileButtonView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 15/02/25.
//

import SwiftUI

struct ProfileButtonView: View {
    
    @State var title: String
    @State var image: String
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                Text(title)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProfileButtonView(title: "Edit Image", image: "square.and.pencil") {
        
    }
}
