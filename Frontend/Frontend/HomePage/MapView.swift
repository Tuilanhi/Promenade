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
//        Map(position: $manager.region, interactionModes: [.pan, .zoom])
//        {
//            UserAnnotation()
//            
//        }
//        .edgesIgnoringSafeArea(.all)
        
        Map {
            UserAnnotation()
        }
    
    }
}

#Preview {
    MapView()
}

extension CLLocationCoordinate2D {
    static let weequahicPark = CLLocationCoordinate2D(latitude: 40.7063, longitude: -74.1973)
    static let empireStateBuilding = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
    static let columbiaUniversity = CLLocationCoordinate2D(latitude: 40.8075, longitude: -73.9626)
}

