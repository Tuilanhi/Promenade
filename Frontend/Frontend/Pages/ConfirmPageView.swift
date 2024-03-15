//
//  ConfirmPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit

struct ConfirmPageView: View {
    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.613, longitude: -96.342),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var getDirections = true
    @State private var routeDisplaying = true
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    @State private var address: String = "161 Wellborn Rd"
    @State private var showOrderPage = false
    
    var body: some View {
        
        if showOrderPage {
            OrderPageView()
        } else {
            VStack {
                Map(position: $cameraPosition) {
                    Annotation("Your Location", coordinate: .userLocation) {
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
                    
                    Marker("Pick up Point", coordinate: .userDestination)
                    
                    
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 6)
                    }
                    
                }
                
                Capsule()
                    .foregroundColor(Color(.systemGray5))
                    .frame(width: 48, height: 6)
                
                HStack {
                    
                    VStack{
                        Circle()
                            .fill(Color(.systemGray3))
                            .frame(width: 8, height: 8)
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width:1, height:32)
                        Rectangle()
                            .fill(.black)
                            .frame(width: 8, height:8)
                        
                    }
                    // walk info
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Your location")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("1:30 PM")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 10)
                        
                        HStack {
                            Text("Zachry")
                                .font(.system(size: 16, weight: .semibold))
                            Spacer()
                            Text("1:45 PM")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding()
                
                
                Divider()
                    .padding(.vertical, 8)
                
                HStack {
                    
                    Button(action: {
                        showOrderPage=true
                    }) {
                        Text("CONFIRM PICK UP POINT")
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width-94, height: 50)
                            .background(.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    //                NavigationView {
                    //                    VStack {
                    //                        NavigationLink(
                    //                            destination: OrderPageView(),
                    //                            isActive: $isOrderPageViewActive
                    //                        ) {
                    //                            EmptyView()
                    //                        }
                    //                        Button(action: {
                    //                            isOrderPageViewActive=true
                    //                        }) {
                    //
                    //                            Text("CONFIRM PICK UP POINT")
                    //                                .fontWeight(.bold)
                    //                                .frame(width: UIScreen.main.bounds.width-94, height: 50)
                    //                                .background(.blue)
                    //                                .cornerRadius(10)
                    //                                .foregroundColor(.white)
                    //                        }
                    //                    }
                    //                }
                    
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
            }
            .background(.white)
            .onAppear {
                fetchRoute()
            }
        }
    }
}

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 30.613, longitude: -96.342)
    }
}

extension CLLocationCoordinate2D {
    static var userDestination: CLLocationCoordinate2D {
        return .init(latitude: 30.619049, longitude: -96.339394)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(center: .userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
}

extension ConfirmPageView {
    
    func fetchRoute() {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: .userLocation))
        request.destination = MKMapItem(placemark: .init(coordinate: .userDestination))
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination =  MKMapItem(placemark: .init(coordinate: .userDestination))
        }
    }
}

#Preview {
    ConfirmPageView()
}
