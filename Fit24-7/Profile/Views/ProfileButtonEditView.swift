//
//  ProfileButtonEditView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 16/02/25.
//

import SwiftUI

struct ProfileButtonEditView: View {
    
    @State var title: String
    @State var backgroundColor: Color
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding()
                .frame(maxWidth: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                )
        }
    }
}

#Preview {
    ProfileButtonEditView(title: "Button", backgroundColor: .primary) {
        
    }
}
