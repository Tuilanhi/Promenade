//
//  RouteView.swift
//  Frontend
//
//  Created by James Stautler on 3/22/24.
//

import SwiftUI
import MapKit

//struct RouteView: View {
//    @Binding var sourceCoordinates: CLLocationCoordinate2D
//    @Binding var destinationCoordinates: CLLocationCoordinate2D
//    @Binding var pickupCoordinates: CLLocationCoordinate2D
//
//    var body: some View {
//        CustomMapView(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, pickupCoordinates: pickupCoordinates)
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//struct CustomMapView: UIViewRepresentable {
//    var sourceCoordinates: CLLocationCoordinate2D
//    var destinationCoordinates: CLLocationCoordinate2D
//    var pickupCoordinates: CLLocationCoordinate2D
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        mapView.userTrackingMode = .follow
//        
//        // Add annotations for source and destination
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.coordinate = sourceCoordinates
//        sourceAnnotation.title = "Start"
//        mapView.addAnnotation(sourceAnnotation)
//        
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.coordinate = destinationCoordinates
//        destinationAnnotation.title = "Destination"
//        mapView.addAnnotation(destinationAnnotation)
//        
//        let pickupAnnotation = MKPointAnnotation()
//        pickupAnnotation.coordinate = pickupCoordinates
//        pickupAnnotation.title = "Rideshare Pickup"
//        mapView.addAnnotation(pickupAnnotation)
//        
//        // Set the visible region of the map
//        let region = MKCoordinateRegion(center: sourceCoordinates, latitudinalMeters: 4000, longitudinalMeters: 4000)
//        mapView.setRegion(region, animated: true)
//        
//        // Rideshare pickup route
//        let pickupRouteRequest = MKDirections.Request()
//        pickupRouteRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinates))
//        pickupRouteRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
//        pickupRouteRequest.transportType = .walking
//        
//        
//        let pickupDirections = MKDirections(request: pickupRouteRequest)
//        pickupDirections.calculate { (response, error) in
//            guard let pickupRoute = response?.routes.first else { return }
//            mapView.addOverlay(pickupRoute.polyline)
//            mapView.setVisibleMapRect(pickupRoute.polyline.boundingMapRect, animated: true)
//        }
//        
//        let destinationRouteRequest = MKDirections.Request()
//        destinationRouteRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
//        destinationRouteRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
//        destinationRouteRequest.transportType = .automobile
//        
//        let destinationDirections = MKDirections(request: destinationRouteRequest)
//        destinationDirections.calculate {(response, error) in
//            guard let destinationRoute = response?.routes.first else {return}
//            mapView.addOverlay(destinationRoute.polyline)
//            mapView.setVisibleMapRect(destinationRoute.polyline.boundingMapRect, animated: true)
//        }
//
//        return mapView
//    }
//    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        // Remove all existing annotations and overlays
//        uiView.removeAnnotations(uiView.annotations)
//        uiView.removeOverlays(uiView.overlays)
//
//        // Add new annotations for the updated source and destination
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.coordinate = sourceCoordinates
//        sourceAnnotation.title = "Start"
//        uiView.addAnnotation(sourceAnnotation)
//
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.coordinate = destinationCoordinates
//        destinationAnnotation.title = "Destination"
//        uiView.addAnnotation(destinationAnnotation)
//        
//        let pickupAnnotation = MKPointAnnotation()
//        pickupAnnotation.coordinate = pickupCoordinates
//        pickupAnnotation.title = "Pickup"
//        uiView.addAnnotation(pickupAnnotation)
//
//        // Draw the new route
//        let pickupRequest = MKDirections.Request()
//        pickupRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinates))
//        pickupRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
//        pickupRequest.transportType = .walking
//
//        let pickupDirections = MKDirections(request: pickupRequest)
//        pickupDirections.calculate { (response, error) in
//            guard let route = response?.routes.first else { return }
//            uiView.addOverlay(route.polyline)
//            uiView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//        }
//        
//        let destinationRequest = MKDirections.Request()
//        destinationRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
//        destinationRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
//        destinationRequest.transportType = .walking
//
//        let destinationDirections = MKDirections(request: destinationRequest)
//        destinationDirections.calculate { (response, error) in
//            guard let route = response?.routes.first else { return }
//            uiView.addOverlay(route.polyline)
//            uiView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//        }
//    }
//
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: CustomMapView
//
//        init(_ parent: CustomMapView) {
//            self.parent = parent
//        }
//        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            guard !(annotation is MKUserLocation) else {
//                // If the annotation is the user's location, return nil to use default view
//                return nil
//            }
//
//            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
//            
//            if annotation.title == "Start" {
//                annotationView.image = UIImage(systemName: "person.fill")
//            } else if annotation.title == "Pickup" {
//                annotationView.image = UIImage(systemName: "hare.fill")
//            } else if annotation.title == "Destination" {
//                annotationView.image = UIImage(systemName: "circle.fill")
//            }
//            
//            annotationView.frame.size = CGSize(width: 20, height: 20)
//            
//            if let title = annotation.title {
//                    let label = UILabel()
//                    label.textAlignment = .center
//                    label.font = UIFont.systemFont(ofSize: 10)
//                    label.text = title
//                    label.numberOfLines = 0 // Allow multiple lines
//                    label.adjustsFontSizeToFitWidth = true // Adjust font size to fit width
//                    label.minimumScaleFactor = 0.5 // Minimum scale factor for adjusting font size
//                    label.frame.size = label.intrinsicContentSize // Adjust frame size based on content size
//                    label.frame.origin.y = annotationView.frame.size.height // Position label underneath image
//                    label.frame.origin.x = (annotationView.frame.size.width - label.frame.size.width) / 2 // Center label horizontally
//                    annotationView.addSubview(label)
//            }
//
//            annotationView.canShowCallout = true
//
//            
//            return annotationView
//        }
//
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            if overlay is MKPolyline {
//                let renderer = MKPolylineRenderer(overlay: overlay)
//                renderer.strokeColor = .blue
//                renderer.lineWidth = 4
//                return renderer
//            }
//            return MKOverlayRenderer()
//        }
//    }
//}

struct RouteView: View {
    @Binding var sourceCoordinates: CLLocationCoordinate2D
    @Binding var destinationCoordinates: CLLocationCoordinate2D
    @Binding var pickupCoordinates: CLLocationCoordinate2D

    var body: some View {
        CustomMapView(sourceCoordinates: sourceCoordinates, destinationCoordinates: destinationCoordinates, pickupCoordinates: pickupCoordinates)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CustomMapView: UIViewRepresentable {
    var sourceCoordinates: CLLocationCoordinate2D
    var destinationCoordinates: CLLocationCoordinate2D
    var pickupCoordinates: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Remove all existing annotations and overlays
        uiView.removeAnnotations(uiView.annotations)
        uiView.removeOverlays(uiView.overlays)

        // Add new annotations for the updated source and destination
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.coordinate = sourceCoordinates
        sourceAnnotation.title = "Start"
        uiView.addAnnotation(sourceAnnotation)

        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationCoordinates
        destinationAnnotation.title = "Destination"
        uiView.addAnnotation(destinationAnnotation)
        
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = pickupCoordinates
        pickupAnnotation.title = "Pickup"
        uiView.addAnnotation(pickupAnnotation)

        // Draw the new route
        let pickupRequest = MKDirections.Request()
        pickupRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinates))
        pickupRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
        pickupRequest.transportType = .walking

        let pickupDirections = MKDirections(request: pickupRequest)
        pickupDirections.calculate { (response, error) in
            guard let route = response?.routes.first else { return }
            uiView.addOverlay(route.polyline)
            uiView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinates))
        destinationRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinates))
        destinationRequest.transportType = .walking

        let destinationDirections = MKDirections(request: destinationRequest)
        destinationDirections.calculate { (response, error) in
            guard let route = response?.routes.first else { return }
            uiView.addOverlay(route.polyline)
            uiView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(_ parent: CustomMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else {
                // If the annotation is the user's location, return nil to use default view
                return nil
            }

            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
            
            if annotation.title == "Start" {
                annotationView.image = UIImage(systemName: "person.fill")
            } else if annotation.title == "Pickup" {
                annotationView.image = UIImage(systemName: "hare.fill")
            } else if annotation.title == "Destination" {
                annotationView.image = UIImage(systemName: "circle.fill")
            }
            
            annotationView.frame.size = CGSize(width: 20, height: 20)
            
            if let title = annotation.title {
                    let label = UILabel()
                    label.textAlignment = .center
                    label.font = UIFont.systemFont(ofSize: 10)
                    label.text = title
                    label.numberOfLines = 0 // Allow multiple lines
                    label.adjustsFontSizeToFitWidth = true // Adjust font size to fit width
                    label.minimumScaleFactor = 0.5 // Minimum scale factor for adjusting font size
                    label.frame.size = label.intrinsicContentSize // Adjust frame size based on content size
                    label.frame.origin.y = annotationView.frame.size.height // Position label underneath image
                    label.frame.origin.x = (annotationView.frame.size.width - label.frame.size.width) / 2 // Center label horizontally
                    annotationView.addSubview(label)
                }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 3
                return renderer
            }
            
            return MKOverlayRenderer()
        }
    }
}
