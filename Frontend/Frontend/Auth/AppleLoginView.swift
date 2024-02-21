//
//  AppleLoginView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI

struct AppleLoginView: View {
    var body: some View {
        // Apple Sign In
        Button(action: {}) {
            HStack {
                Image("Apple")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 8)
                Text("Sign in with Apple ID")
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
    AppleLoginView()
}
