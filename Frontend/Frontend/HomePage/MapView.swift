//
//  MapView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI
import MapKit

// Add a simple MapView using MapKit
struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a dummy region for preview purposes
        let previewRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437), // Example coordinates (e.g., Los Angeles)
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        
        // Pass the dummy region to MapView
        MapView(region: .constant(previewRegion))
    }
}
