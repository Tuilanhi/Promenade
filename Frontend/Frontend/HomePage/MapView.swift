//
//  MapView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locationManager = MapLocationManager()

    var body: some View {
        Map(position: $locationManager.cameraPosition)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Button(action: {
                    locationManager.centerMapOnUserLocation()
                }) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .padding(.all, 15)
                }, alignment: .bottomTrailing
            )
    }
}
