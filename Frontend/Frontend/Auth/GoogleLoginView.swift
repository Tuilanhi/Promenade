//
//  GoogleLoginView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI

struct GoogleLoginView: View {
    var body: some View {
        VStack {
            Button(action: {} ) {
                Text("Sign in with Google")
                  .padding(.vertical, 10)
                  .frame(maxWidth: 300)
                  .background(alignment: .leading) {
                      Image("Google")
                          .resizable()
                          .frame(width: 50.0, height: 50.0)
                  }
              }
              .foregroundColor(.black)
              .buttonStyle(.bordered)
        }
    }
}

#Preview {
    GoogleLoginView()
}
