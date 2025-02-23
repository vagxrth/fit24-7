//
//  ProfileView.swift
//  Fit24-7
//
//  Created by Vagarth Pandey on 13/02/25.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var viewModel = ProfileViewModel()
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(spacing: 16) {
                        Button {
                            withAnimation {
                                viewModel.presentEditImage()
                            }
                        } label: {
                            Image(viewModel.profileImage ?? "machine")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.gray.opacity(0.25))
                                )
                        }
                        VStack(alignment: .leading) {
                            Text(Date.now.timeOfDayGreeting())
                                .font(.title)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
                            
                            Text(viewModel.profileName ?? "Name")
                                .font(.title2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
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
                                viewModel.editName()
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
                        .frame(maxWidth: .infinity, alignment: .center)
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
                    
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.15))
                        )
                    
                    
                    VStack {
                        ProfileButtonView(title: "Contact Us", image: "envelope") {
                            viewModel.presentEmailApp()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.15))
                        )
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .sheet(isPresented: $viewModel.presentGoal) {
                        EditGoalsView()
                            .presentationDetents([.fraction(0.55)])
                            .environment(viewModel)
                    }
                    .alert("Oops", isPresented: $viewModel.showAlert) {
                        Button(role: .cancel) {
                            viewModel.showAlert = false
                        } label: {
                            Text("Ok")
                        }
                    } message: {
                        Text("We were unable to open your mail application. Please make sure you have one installed.")
                    }
                }
                .navigationTitle("Profile")
            }
        }
    }
}

#Preview {
    ProfileView()
}
