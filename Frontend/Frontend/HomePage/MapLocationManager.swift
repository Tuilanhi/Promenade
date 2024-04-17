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
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        cameraPosition = MapCameraPosition.region(initialRegion)
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func centerMapOnUserLocation() {
        guard let location = locationManager.location else { return }
        let newRegion = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        cameraPosition = MapCameraPosition.region(newRegion)
    }
}


