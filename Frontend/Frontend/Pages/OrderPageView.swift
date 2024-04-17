////
////  OrderPageView.swift
////  Frontend
////
////  Created by nhi vu on 2/20/24.
////
////
//

import SwiftUI
import MapKit
import Firebase

struct OrderPageView: View {
    
    let userPickup: CLLocationCoordinate2D
    @State private var userCurrentLocation: CLLocationCoordinate2D
    @State private var directions: [String] = []
    
    @State private var stepIndex: Int = 0
    
    @State private var route: MKRoute?
    @State private var segmentLine: MKPolyline?
    @State private var startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    
    @State private var pickupCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var dropoffCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    init(userCurrentLocation: CLLocationCoordinate2D, userPickup: CLLocationCoordinate2D) {
        self._userCurrentLocation = State(initialValue: userCurrentLocation)
        self.userPickup = userPickup
    }
    
    var body: some View {
        
        
        
        NavigationView {
            
            VStack {
                
                
                Map/*(position: $cameraPosition)*/ {
                    
                    Annotation("Starting Point", coordinate: startCoordinate) {
                        Image(systemName: "circle.fill").foregroundColor(.black).font(.system(size: 25))
                    }
                    
                    Marker("Pickup Point", coordinate: userPickup)
                    
                    
                    if let route = route, let completeRoute = completeRoute(location: segmentLine, fullRoute: route) {
                        MapPolyline(completeRoute).stroke(.blue, lineWidth: 6)
                    }
                    
                    if let segmentLine = segmentLine {
                        MapPolyline(segmentLine)
                            .stroke(.green, lineWidth: 6)
                    }
                    
                }
                
                VStack {
                    
                    HStack {
                        
                        
                        Button(action: {
                            if stepIndex > 0 {
                                stepIndex -= 1
                                fetchStepSegment()
                            }
                        }) {
                            Image(systemName: "chevron.left")
                        }
                        
                        Spacer()
                        
                        if directions.indices.contains(stepIndex) {
                            Text(directions[stepIndex])
                                .multilineTextAlignment(.center)
                                .padding()
                                .foregroundColor(.black)
                        } else {
                            Text("directions not available")
                                .padding()
                        }
                        
                        
                        Spacer()
                        
                        Button(action: {
                            if stepIndex < directions.count - 1 {
                                stepIndex += 1
                                fetchStepSegment()
                            }
                        }) {
                            Image(systemName: "chevron.right")
                        }
                        
                    }
                    .padding()
                    .foregroundColor(.blue)
           
                }
                .padding(.leading, 8)
                
                Divider()
                    .padding(.vertical, 8)
                
                HStack {
                    Button(action: {
                        openUberWithCoordinates()
                    }) {
                        Text("Order Uber")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.white)
            .onAppear {
                self.startCoordinate = self.userCurrentLocation
                fetchRoute()
                fetchDirections()
                fetchCurrentRouteFromFirestore()
            }
        }
    }
    
    private func fetchCurrentRouteFromFirestore() {
        let db = Firestore.firestore()
        db.collection("current-route").document("user-current-route").getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if let pickupPoint = data["pickupPointCoordinates"] as? GeoPoint,
                       let destination = data["destinationCoordinates"] as? GeoPoint {
                        self.pickupCoordinates = CLLocationCoordinate2D(latitude: pickupPoint.latitude, longitude: pickupPoint.longitude)
                        self.dropoffCoordinates = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
                        
                        // Print the coordinates to verify
                        print("Pickup Coordinates: \(self.pickupCoordinates.latitude), \(self.pickupCoordinates.longitude)")
                        print("Dropoff Coordinates: \(self.dropoffCoordinates.latitude), \(self.dropoffCoordinates.longitude)")
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func openUberWithCoordinates() {
        print("Opening Uber with Pickup Coordinates: \(pickupCoordinates.latitude), \(pickupCoordinates.longitude)")
        print("Opening Uber with Dropoff Coordinates: \(dropoffCoordinates.latitude), \(dropoffCoordinates.longitude)")
        
        let uberURL = "uber://?action=setPickup&client_id=W9IJVfDtraQeCVxSeWFYfxtpE2InanIl&pickup[latitude]=\(pickupCoordinates.latitude)&pickup[longitude]=\(pickupCoordinates.longitude)&dropoff[latitude]=\(dropoffCoordinates.latitude)&dropoff[longitude]=\(dropoffCoordinates.longitude)"
        if let url = URL(string: uberURL) {
            UIApplication.shared.open(url)
        }
    }
    
    private func fetchRoute() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: userCurrentLocation))
        request.destination = MKMapItem(placemark: .init(coordinate: userPickup))
        request.transportType = .walking
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            fetchStepSegment()
        }
    }
    
    private func fetchDirections() {
        walkingDirections(start: userCurrentLocation, end: userPickup) { steps in
            self.directions = steps
        }
    }
    
    private func walkingDirections(start userCurrentLocation: CLLocationCoordinate2D, end userPickup: CLLocationCoordinate2D, completion: @escaping ([String]) -> Void) {
        let from = MKPlacemark(coordinate: userCurrentLocation)
        let to = MKPlacemark(coordinate: userPickup)
        
        let fromItem = MKMapItem(placemark: from)
        let toItem = MKMapItem(placemark: to)
        
        let req = MKDirections.Request()
        req.source = fromItem
        req.destination = toItem
        req.transportType = .walking
        
        let directions = MKDirections(request: req)
        
        directions.calculate { (res, err) in
            if let err = err {
                print("Error calculating directions: \(err.localizedDescription)")
                completion([])
                return
            }
            
            guard let path = res?.routes.first else {
                print("No path available")
                completion([])
                return
            }
            
            var steps = [String]()
            for x in path.steps {
                steps.append(x.instructions)
            }
            completion(steps)
        }
    }
    
    private func fetchStepSegment() {
        guard let segment = route else {
            return
        }
        
        let step = segment.steps[stepIndex]
        
        guard step.polyline.pointCount >= 2 else {
            return
        }
        
        let segmentStart = step.polyline.points()[0]
        let segmentEnd = step.polyline.points()[step.polyline.pointCount - 1]
        
        startCoordinate = CLLocationCoordinate2D(latitude: segmentStart.coordinate.latitude, longitude: segmentStart.coordinate.longitude)
        
        segmentLine = segment.polyline.trim(from: segmentStart, to: segmentEnd)
        
    }
    
    private func completeRoute (location segment: MKPolyline?, fullRoute route: MKRoute) -> MKPolyline? {
        guard let segment = segment else {
            return route.polyline
        }
        
        let points = route.polyline.points()
        let segPoints = segment.points()
        
        var endIndex = 0
        
        for i in 0..<route.polyline.pointCount {
            let position = points[i]
            if position.x == segPoints[0].x && position.y == segPoints[0].y {
                endIndex = i
            }
        }
        
        var endPoints = [MKMapPoint]()
        for i in endIndex..<route.polyline.pointCount {
            endPoints.append(points[i])
        }
        
        return MKPolyline(points: endPoints, count: endPoints.count)
    }
    
}

extension MKPolyline {
    
    func trim (from segmentStart: MKMapPoint, to segmentEnd: MKMapPoint) -> MKPolyline {
        var segmentStartIndex = 0
        var segmentEndIndex = 0
        var startSelected = false
        var endSelected = false
        
        let mapPoints = self.points()
        
        for i in 0..<self.pointCount {
            
            let currentPoint = mapPoints[i]
            
            if !startSelected && currentPoint.x == segmentStart.x && currentPoint.y == segmentStart.y {
                segmentStartIndex = i
                startSelected = true
            }
            
            if !endSelected && currentPoint.x == segmentEnd.x && currentPoint.y == segmentEnd.y {
                segmentEndIndex = i
                endSelected = true
            }
            
            if startSelected && endSelected {
                break
            }
        }
        
        let segmentPoints = (segmentStartIndex...segmentEndIndex).map {mapPoints[$0]}

        return MKPolyline(points: segmentPoints, count: segmentEndIndex - segmentStartIndex + 1)
    }
    
}



#Preview {
    OrderPageView(userCurrentLocation: CLLocationCoordinate2D(latitude: 0,longitude: 0), userPickup: CLLocationCoordinate2D(latitude: 0, longitude: 0))
}
