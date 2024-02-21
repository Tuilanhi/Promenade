//
//  LoginPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginPageView: View {
    @State private var userLoggedIn = (Auth.auth().currentUser != nil)
    
    var body: some View {
        VStack {
            if userLoggedIn{
                HomePageView()
            } else {
                VStack{
                    // Google Login
                    GoogleLoginView()
                    
                    AppleLoginView()
                }.padding()
            }
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if (user != nil) {
                    userLoggedIn = true
                } else {
                    userLoggedIn = false
                }
            }
        }
    }
}

#Preview {
    LoginPageView()
}
