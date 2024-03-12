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
        .edgesIgnoringSafeArea(.all)
    }
}
