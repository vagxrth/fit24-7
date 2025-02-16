//
//  ProfileView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 13/02/25.
//

import SwiftUI

struct ProfileView: View {
    
    @AppStorage("profileView") var profileName: String?
    @AppStorage("profileImage") var profileImage: String?
    
    @State private var isEditingName = true
    @State private var isEditingImage = false
    @State private var currentName = ""
    @State private var selectedImage: String?
    
    @State private var images = ["bench", "machine", "press", "rowing", "weight"]
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(profileImage ?? "machine")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                    .onTapGesture {
                        isEditingImage = true
                    }
                VStack(alignment: .leading) {
                    Text("Good Morning!")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    Text(profileName ?? "Vagarth")
                        .font(.title)
                }
            }
            
            if isEditingName {
                TextField("Your Name...", text: $currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                HStack {
                    Button {
                        isEditingName = false
                    } label: {
                        Text("Cancel")
                            .padding()
                            .frame(maxWidth: 200)
                            .foregroundColor(.red)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.gray.opacity(0.1))
                            )
                    }
                    Button {
                        if !currentName.isEmpty {
                            withAnimation {
                                profileName = currentName
                                isEditingName = false
                            }
                        }
                    } label: {
                        Text("Done")
                            .padding()
                            .frame(maxWidth: 200)
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.primary)
                            )
                    }
                }
            }
            
            if isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) {
                            image in Button {
                                withAnimation {
                                    selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    
                                    if selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.primary)
                                    }
                                    
                                }
                                .padding()
                            }
                        }
                    }
                }
                .background (
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                )
                
                Button {
                    withAnimation {
                        profileImage = selectedImage
                        isEditingImage = false
                    }
                } label: {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: 200)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.primary)
                        )
                }
            }
            
            VStack {
                ProfileButtonView(title: "Edit Name", image: "square.and.pencil") {
                    isEditingName = true
                }
                
                ProfileButtonView(title: "Edit Image", image: "square.and.pencil") {
                    isEditingImage = true
                }
            }
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            
            VStack {
                ProfileButtonView(title: "Contact Us", image: "envelope") {
                    print("Contact Us")
                }
                
                ProfileButtonView(title: "Privacy Policy", image: "document") {
                    print("Privacy Policy")
                }
                
                ProfileButtonView(title: "Terms of Service", image: "rectangle.and.pencil.and.ellipsis") {
                    print("Terms of Service")
                }
            }
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear {
            selectedImage = profileImage
        }
    }
}

#Preview {
    ProfileView()
}
