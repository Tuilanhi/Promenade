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

struct OrderPageView: View {
    
    let userPickup: CLLocationCoordinate2D
    @State private var userCurrentLocation: CLLocationCoordinate2D
    @State private var directions: [String] = []
    
    @State private var stepIndex: Int = 0
    
    @State private var route: MKRoute?
    @State private var segmentLine: MKPolyline?
    @State private var startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    
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
                
//                    if let route {
//                        MapPolyline(route.polyline)
//                            .stroke(.blue, lineWidth: 6)
//                    }
                    
                    if let segmentLine = segmentLine {
                        MapPolyline(segmentLine)
                            .stroke(.green, lineWidth: 6)
                    }
//                    } else if let route = route {
//                        MapPolyline(route.polyline)
//                            .stroke(.blue, lineWidth: 6)
//                    }
                    
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
                        if let url = URL(string: "https://www.uber.com/") {
                            UIApplication.shared.open(url)
                        }
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
            }
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
//        let coordPoints = step.polyline.points()
        
        guard step.polyline.pointCount >= 2 else {
            return
        }
        
        let segmentStart = step.polyline.points()[0]
        let segmentEnd = step.polyline.points()[step.polyline.pointCount - 1]
        
        startCoordinate = CLLocationCoordinate2D(latitude: segmentStart.coordinate.latitude, longitude: segmentStart.coordinate.longitude)
        
        segmentLine = segment.polyline.trim(from: segmentStart, to: segmentEnd)
        
        
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
