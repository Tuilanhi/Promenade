import SwiftUI
import MapKit
import Firebase
import CoreLocation

struct OrderPageView: View {
    
    @StateObject private var locationManagerWrapper = LocationManagerWrapper()
    @State private var userCurrentLocation: CLLocationCoordinate2D?
    
    let userPickup: CLLocationCoordinate2D
    @State private var directions: [String] = []
    @State private var stepIndex: Int = 0
    @State private var route: MKRoute?
    @State private var segmentLine: MKPolyline?
    @State private var startCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var pickupCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var dropoffCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    init(userCurrentLocation: CLLocationCoordinate2D, userPickup: CLLocationCoordinate2D) {
        self.userCurrentLocation = userCurrentLocation
        self.userPickup = userPickup
    }
    
    var body: some View {
        
        
        
        NavigationView {
            
            VStack {
                Map {
                    if let userLocation = userCurrentLocation {
                        Annotation("User Location", coordinate: userLocation) {
                            Image(systemName: "mappin.circle.fill").foregroundColor(.blue).font(.system(size: 25))
                        }
                    }
                    
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
                .onAppear {
                    fetchUserLocation()
                    if let location = userCurrentLocation {
                        self.startCoordinate = location
                    }
                    fetchRoute()
                    fetchDirections()
                    fetchCurrentRouteFromFirestore()
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
        }
    }
    
    private func fetchUserLocation() {
        locationManagerWrapper.startUpdatingLocation { location in
            userCurrentLocation = location?.coordinate
        }
    }
    
    private func fetchCurrentRouteFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: User is not authenticated.")
            return
        }

        let db = Firestore.firestore()
        // Update the path to reference the user-specific 'current-route' document
        let currentRouteRef = db.collection("users").document(userId).collection("current-route").document("user-current-route")

        currentRouteRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if let pickupPoint = data["sourceCoordinates"] as? GeoPoint,
                       let destination = data["destinationCoordinates"] as? GeoPoint {
                        self.pickupCoordinates = CLLocationCoordinate2D(latitude: pickupPoint.latitude, longitude: pickupPoint.longitude)
                        self.dropoffCoordinates = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)

                        print("Pickup Coordinates: \(self.pickupCoordinates.latitude), \(self.pickupCoordinates.longitude)")
                        print("Dropoff Coordinates: \(self.dropoffCoordinates.latitude), \(self.dropoffCoordinates.longitude)")
                    }
                }
            } else {
                print("Document does not exist in user's 'current-route'. User ID: \(userId)")
            }
        }
    }
    
    private func openUberWithCoordinates() {
        let uberURL = "uber://?action=setPickup&client_id=W9IJVfDtraQeCVxSeWFYfxtpE2InanIl&pickup[latitude]=\(pickupCoordinates.latitude)&pickup[longitude]=\(pickupCoordinates.longitude)&dropoff[latitude]=\(dropoffCoordinates.latitude)&dropoff[longitude]=\(dropoffCoordinates.longitude)"
        if let url = URL(string: uberURL) {
            UIApplication.shared.open(url)
        }
    }
    
    private func fetchRoute() {
        guard let currentLocation = userCurrentLocation else {
            print("User's current location is not available.")
            return
        }
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: currentLocation))
        request.destination = MKMapItem(placemark: .init(coordinate: userPickup))
        request.transportType = .walking
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            fetchStepSegment()
        }
    }
    
    private func fetchDirections() {
        guard let currentLocation = userCurrentLocation else {
            print("User's current location is not available.")
            return
        }
        
        walkingDirections(start: currentLocation, end: userPickup) { steps in
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

// Location Manager Wrapper to handle Core Location updates
class LocationManagerWrapper: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func startUpdatingLocation(completion: @escaping (CLLocation?) -> Void) {
        DispatchQueue.main.async {
            completion(self.lastKnownLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            lastKnownLocation = location
        }
    }
}

struct OrderPageView_Previews: PreviewProvider {
    static var previews: some View {
        OrderPageView(userCurrentLocation: CLLocationCoordinate2D(latitude: 0, longitude: 0), userPickup: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    }
}

