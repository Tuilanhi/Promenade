//
//  MapLocationManager.swift
//  Frontend
//
//  Created by Nhi Vu on 4/16/24.
//
import Foundation
import CoreLocation
import MapKit
import SwiftUI

class MapLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var cameraPosition: MapCameraPosition

    override init() {
        // Placeholder region that will be updated with the user's location.
        let placeholderRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        cameraPosition = MapCameraPosition.region(placeholderRegion)
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse ||
            manager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else if manager.authorizationStatus == .denied {
            // Handle the case where user has denied the location service.
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            centerMapOnLocation(location: location)
            locationManager.stopUpdatingLocation() // To stop further updates.
        }
    }

    func centerMapOnUserLocation() {
        guard let location = locationManager.location else { return }
        centerMapOnLocation(location: location)
    }

    private func centerMapOnLocation(location: CLLocation) {
        let newRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        cameraPosition = MapCameraPosition.region(newRegion)
    }
}



