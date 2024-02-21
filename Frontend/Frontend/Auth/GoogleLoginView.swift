//
//  GoogleLoginView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI

struct GoogleLoginView: View {
    @State private var err: String = ""
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await GoogleAuthentication().googleOauth()
                    // Handle successful authentication
                } catch {
                    print(error)
                    err = error.localizedDescription
                }
            }
        }) {
            HStack {
                Image("Google")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 8)
                Text("Sign in with Google")
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(.black)
        .buttonStyle(.bordered)
        .padding()
    
    }
}

#Preview {
    GoogleLoginView()
}
