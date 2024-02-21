//
//  AccountPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct AccountPageView: View {
    @State private var fullName: String = ""
    @State private var emailAddress: String = ""
    @State private var isLoggingOut = false

    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                // User information
                Group {
                    Text("Account Info")
                        .font(.headline)
                        .padding(.vertical)
                    
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(fullName)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(emailAddress)
                    }
                    
                    Divider()
                    
                    // Navigation Link to SavedAddressView
                    NavigationLink(destination: SavedAddressView()) {
                        HStack {
                            Image(systemName: "star.fill") // Use your house icon here
                                .foregroundColor(.black)
                            VStack(alignment: .leading) {
                                Text("Saved Address")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                // Logout button
                Button(action: logout) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
                .padding()
                .disabled(isLoggingOut)
            }
            .padding()
            .onAppear {
                loadGoogleUserInfo()
            }
        }
    }
    
    private func loadGoogleUserInfo() {
        if let user = LoadUserInfo.loadGoogleUser() {
            self.fullName = user.profile?.name ?? "No Name"
            self.emailAddress = user.profile?.email ?? "No Email"
        } else {
            // User is not logged in; handle accordingly
        }
    }
    
    private func logout() {
        isLoggingOut = true
        Task {
            do {
                try await GoogleAuthentication().logout()
                // Perform further actions like navigating to a login screen
            } catch {
                // Handle errors if necessary
                print(error.localizedDescription)
            }
            isLoggingOut = false
        }
    }
}

