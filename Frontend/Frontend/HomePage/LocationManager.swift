//
//  LocationManager.swift
//  Frontend
//
//  Created by nhi vu on 3/3/24.
//

import Foundation
import MapKit
import _MapKit_SwiftUI

final class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var region = MapCameraPosition.region(MKCoordinateRegion(
        center: .init(latitude: 37.334_900, longitude: -122.009_020),
        span: .init(latitudeDelta: 0.2, longitudeDelta: 0.2)
    ))
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setup()
    }
    
    func setup() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways else { return }
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.last {
            userLocation = location
            region = MapCameraPosition.region(MKCoordinateRegion(
                center: location.coordinate,
                span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ))
        }
    }
}
