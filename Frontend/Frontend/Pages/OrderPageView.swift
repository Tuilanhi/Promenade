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
    
    init(userCurrentLocation: CLLocationCoordinate2D, userPickup: CLLocationCoordinate2D) {
        self._userCurrentLocation = State(initialValue: userCurrentLocation)
        self.userPickup = userPickup
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Map/*(position: $cameraPosition)*/ {
                    Annotation("Your Location", coordinate: userCurrentLocation) {
                        ZStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.blue.opacity(0.25))
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Circle()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Marker("Pickup Point", coordinate: userPickup)
                
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 6)
                    }
                    
                }
                
                VStack {
                  
                    HStack {
                       
                        
                        Button(action: {
                            if stepIndex > 0 {
                                stepIndex -= 1
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
}


#Preview {
    OrderPageView(userCurrentLocation: CLLocationCoordinate2D(latitude: 0,longitude: 0), userPickup: CLLocationCoordinate2D(latitude: 0, longitude: 0))
}
