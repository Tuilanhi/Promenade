//
//  HomePageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit

struct HomePageView: View {
    // State variable to hold the map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // Example coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack {
            SearchBarView()
            
            MapView(region: $region)
                .frame(height: .infinity) // Set the frame to whatever size you prefer
        }
    }
}

#Preview {
    HomePageView()
}
