//
//  HomePageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit

struct HomePageView: View {
    @State private var navigateToDestinationSelection = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    self.navigateToDestinationSelection = true
                }) {
                    SearchBarView()
                }
                .buttonStyle(PlainButtonStyle())
                
                MapView()
            }
            .navigationDestination(isPresented: $navigateToDestinationSelection) {
                  DestinationSelectionPageView()
              }
        }
    }
}

#Preview {
    HomePageView()
}
