//
//  ContentView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct ContentView: View {
    var body: some View {
        LoginPageView().onOpenURL(perform: { url in
            GIDSignIn.sharedInstance.handle(url)
        })
    }
}

#Preview {
    ContentView()
}
