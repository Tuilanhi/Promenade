//
//  RouteView.swift
//  Frontend
//
//  Created by James Stautler on 3/22/24.
//

import SwiftUI
import MapKit

// Add a simple MapView using MapKit

// Pass source and destination coordinates as parameters to the view constructor
//struct RouteView: View {
//    @StateObject var manager = LocationManager()
//
//    @Binding var sourceCoordinates: CLLocationCoordinate2D
//    @Binding var destinationCoordinates: CLLocationCoordinate2D
//    
//
//    init(_ sourceCoordinates: Binding<CLLocationCoordinate2D>, _ destinationCoordinates: Binding<CLLocationCoordinate2D>) {
//        self._destinationCoordinates = destinationCoordinates
//        self._sourceCoordinates = sourceCoordinates
//    }
//    
//
//    var body: some View {
//        
////        var coordinates = [sourceCoordinates, destinationCoordinates]
////        var path: MKPolyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
//        
//        Map
//        {
//            Marker("Start", coordinate: sourceCoordinates)
//            Marker("Destination", coordinate: destinationCoordinates)
//        }
//        .overlay(
//            Path { path in
//                path.move(to: .init(x: sourceCoordinates.latitude, y: sourceCoordinates.longitude))
//                path.addLine(to: .init(x: destinationCoordinates.latitude, y: destinationCoordinates.longitude))
//            }
//            .stroke(Color.blue, lineWidth: 3)
//        )
//        .edgesIgnoringSafeArea(.all)
//    }
//}


class RouteViewController:UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var savedLocation: CLLocation?
    private var svaedPolyline: MKPolyline?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorisation()
        setupLocationManager()
        setDelegates()
        setupMapView()
    }
}

private extension RouteViewController {
    func setDelegates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
    }
    
    func setupMapView() {
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.userTrackingMode = .followWithHeading
    }
    
    func setupLocationManager() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func requestAuthorisation() {
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied, .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
}
    
extension RouteViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last(where: { $0.horizontalAccuracy >= 0 }) else { return }
        
        var polyline: MKPolyline?
        
        if let oldCoordinate = savedLocation?.coordinate {
            let coordinates = [oldCoordinate, location.coordinate]
            polyline = MKPolyline(coordinates: coordinates,
                                  count: coordinates.count)
            if let polyline = polyline {
                mapView.addOverlay(polyline)
            }
        }
        savedLocation = location
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}

extension RouteViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        switch overlay {
        case let polyline as MKPolyline:
            
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .red
            renderer.lineWidth = 5
            return renderer
            
        default:
            fatalError("Unexpected MKOverlay type")
        }
    }
}

struct RouteViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RouteViewController {
        let routeViewController = RouteViewController()
        return routeViewController
    }

    func updateUIViewController(_ uiViewController: RouteViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct RouteView: View {
    var body: some View {
        RouteViewControllerRepresentable()
    }
}

