//
//  ConfirmPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit
import CoreLocation
import Firebase


struct ConfirmPageView: View {
//    @State private var cameraPosition: MapCameraPosition = .region(.userRegion)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.613, longitude: -96.342),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var getDirections = true
    @State private var routeDisplaying = true
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    @State public var address: String = ""
    @State private var showOrderPage = false
    
    
    let currentTime: String
    let destinationTime: String
    
    let userPickup: CLLocationCoordinate2D
//    let userCurrentLocation: CLLocationCoordinate2D
    @State private var userCurrentLocation: CLLocationCoordinate2D
    
    init(currentTime: String, destinationTime: String, userCurrentLocation: CLLocationCoordinate2D, userPickup: CLLocationCoordinate2D) {
        self.currentTime = currentTime
        self.destinationTime = destinationTime
        self.userCurrentLocation = userCurrentLocation
        self.userPickup = userPickup
    }

    // Fetch the userId from Firebase Authentication
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        
        if showOrderPage {
            OrderPageView(userCurrentLocation: userCurrentLocation, userPickup: userPickup)
        } else {
            NavigationView{
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
                        
                        // need to get coordinate from ride selection
                        Marker("Pickup Point", coordinate: userPickup)
                    
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
                                Text(currentTime)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                            .padding(.bottom, 10)
                            
                            HStack {
//                                Text("Destination")
//                                Text(getAddressFromCoordinates(userPickup: userPickup))
//                                    .font(.system(size: 16, weight: .semibold))
                                Text(address)
                                      .font(.system(size: 16, weight: .semibold))
                                      .onAppear {
                                          //getAddress(userPickup: userPickup)
                                          getAddress(userPickup: userPickup) { fetchedAddress in
                                              self.address = fetchedAddress
                                          }
                                      }
                                Spacer()
                                Text(destinationTime)
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
                            addCurrentRouteToPastRoutes()
                            showOrderPage=true
                        }) {
                            Text("CONFIRM PICK UP POINT")
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width-94, height: 50)
                                .background(.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical)
                }
                .background(.white)
                .onAppear {
                    fetchRoute()
                }
            }
        }
    }
    
    func addCurrentRouteToPastRoutes() {
        guard let userId = userId else {
            print("Error: User is not authenticated.")
            return
        }

        let db = Firestore.firestore()

        // Reference to the user-specific 'current-route' document
        let currentRouteRef = db.collection("users").document(userId).collection("current-route").document("user-current-route")

        currentRouteRef.getDocument { (document, error) in
            if let error = error {
                // Handle the error appropriately
                print("Error fetching current route: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("Document does not exist in user's 'current-route'")
                return
            }

            // Prepare the data to add to 'past-routes', including a timestamp
            var pastRouteData = data
            pastRouteData["timestamp"] = FieldValue.serverTimestamp()

            // Reference to the user-specific 'past-routes' collection
            let pastRoutesRef = db.collection("users").document(userId).collection("past-routes")

            pastRoutesRef.addDocument(data: pastRouteData) { error in
                if let error = error {
                    // Handle the error appropriately
                    print("Error adding document to user's past routes: \(error.localizedDescription)")
                } else {
                    print("Current route successfully added to user's past routes.")
                }
            }
        }
    }
}


func getAddress(userPickup: CLLocationCoordinate2D,  completion: @escaping (String) -> Void) {
    
    let coords = CLLocation(latitude: userPickup.latitude, longitude: userPickup.longitude)
    let geocoder = CLGeocoder()
    var addressParts = [String]()
    
    geocoder.reverseGeocodeLocation(coords) { (placemarks, error) in
        guard let placemark = placemarks?.first else {
            print("Placemark error")
            return
        }
        
        
        let number = placemark.subThoroughfare ?? ""
     
        if let street = placemark.thoroughfare {
            addressParts.append(street)
        }
        if let city = placemark.locality {
            addressParts.append(city)
        }
        if let state = placemark.administrativeArea {
            addressParts.append(state)
        }
       
        let address = number + " " + addressParts.joined(separator: ", ")
        completion(address)
     
    }
}
    
    
extension ConfirmPageView {
        
    func fetchRoute() {
            
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: userCurrentLocation))
        request.destination = MKMapItem(placemark: .init(coordinate: userPickup))
        request.transportType = .walking
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination =  MKMapItem(placemark: .init(coordinate: userPickup))
        }
    }
}
    
#Preview {
    ConfirmPageView(currentTime: "", destinationTime: "",
                    userCurrentLocation: CLLocationCoordinate2D(latitude: 0,longitude: 0),
                    userPickup: CLLocationCoordinate2D(latitude: 0, longitude: 0))
}
    
