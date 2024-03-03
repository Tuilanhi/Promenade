//
//  MapView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI
import MapKit

// Add a simple MapView using MapKit
struct MapView: View {
    @StateObject var manager = LocationManager()
        
    var body: some View {
        Map(position: $manager.region)
        {
            UserAnnotation()
        }
        .overlay(
            // This Circle will use the center of the current region as its center
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 100, height: 100)
                .offset(x: 0, y: 0), alignment: .center
        )
    }
}
