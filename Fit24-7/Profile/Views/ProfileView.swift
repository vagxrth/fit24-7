//
//  ProfileView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 13/02/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(viewModel.selectedImage ?? "machine")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                    .onTapGesture {
                        withAnimation {
                            viewModel.presentEditImage()
                        }
                    }
                VStack(alignment: .leading) {
                    Text("Good Morning!")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    Text(viewModel.profileName ?? "Vagarth")
                        .font(.title)
                }
            }
            
            if viewModel.isEditingName {
                TextField("Your Name...", text: $viewModel.currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                HStack {
                    
                    ProfileButtonEditView(title: "Cancel", backgroundColor: .gray.opacity(0.1)) {
                        withAnimation {
                            viewModel.dismissEdit()
                        }
                    }
                    .foregroundColor(.red)
                    
                    ProfileButtonEditView(title: "Done", backgroundColor: .blue) {
                        if !viewModel.currentName.isEmpty {
                            viewModel.editName()
                        }
                    }
                    .foregroundColor(.white)
                }
            }
            
            if viewModel.isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.images, id: \.self) {
                            image in Button {
                                withAnimation {
                                    viewModel.selectNewImage(name: image)
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    
                                    if viewModel.selectedImage == image {
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
                
                ProfileButtonEditView(title: "Done", backgroundColor: .blue) {
                    withAnimation {
                        viewModel.editImage()
                    }
                }
                .foregroundColor(.white)
                .padding(.bottom)
            }
            
            VStack {
                ProfileButtonView(title: "Edit Name", image: "square.and.pencil") {
                    withAnimation {
                        viewModel.presentEditName()
                    }
                }
                
                ProfileButtonView(title: "Edit Image", image: "square.and.pencil") {
                    withAnimation {
                        viewModel.presentEditImage()
                    }
                }
            }
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            
            VStack {
                ProfileButtonView(title: "Contact Us", image: "envelope") {
                    viewModel.presentEmailApp()
                }
                
                Link(destination: URL(string: "https://github.com/vagxrth")!) {
                    HStack {
                        Image(systemName: "document")
                        Text("Privacy Policy")
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Link(destination: URL(string: "https://github.com/vagxrth")!) {
                    HStack {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        Text("Terms of Service")
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background (
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert("Oops!", isPresented: $viewModel.showAlert, actions: {
            Text("Ok")
        }, message: {
            Text("Unable to open Mail application.")
        })
    }
}

#Preview {
    ProfileView()
}
