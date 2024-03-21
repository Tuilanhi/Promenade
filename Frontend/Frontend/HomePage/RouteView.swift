//
//  RouteView.swift
//  Frontend
//
//  Created by James Stautler on 3/21/24.
//

import SwiftUI
import MapKit

// Add a simple MapView using MapKit
struct RouteView: View {
    @StateObject var manager = LocationManager()
    
    @Binding var sourceCoordinates: CLLocationCoordinate2D
    @Binding var destinationCoordinates: CLLocationCoordinate2D
    
    init(_ destinationCoordinates: Binding<CLLocationCoordinate2D>, _ sourceCoordinates: Binding<CLLocationCoordinate2D>) {
        self._destinationCoordinates = destinationCoordinates
        self._sourceCoordinates = sourceCoordinates
    }
        
    var body: some View {
        Map
        {
            Marker("Start", coordinate: sourceCoordinates)
            Marker("Destination", coordinate: destinationCoordinates)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

