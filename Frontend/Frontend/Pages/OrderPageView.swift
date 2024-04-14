import SwiftUI
import MapKit
import Firebase
import CoreLocation

struct OrderPageView: View {
    
    let userPickup: CLLocationCoordinate2D
    @State private var userCurrentLocation: CLLocationCoordinate2D
    @State private var directions: [String] = []
    
    @State private var stepIndex: Int = 0
    
    @State private var route: MKRoute?
    
    @State private var pickupCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @State private var dropoffCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @StateObject private var locationViewModel = LocationViewModel()
    
    init(userCurrentLocation: CLLocationCoordinate2D, userPickup: CLLocationCoordinate2D) {
        self._userCurrentLocation = State(initialValue: userCurrentLocation)
        self.userPickup = userPickup
    }
    
    var body: some View {
        NavigationView {
            VStack {
                MapViewer(userLocation: $userCurrentLocation, pickupLocation: userPickup, route: $route)
                    .onAppear {
                        fetchRoute()
                        fetchDirections()
                        fetchCurrentRouteFromFirestore()
                        locationViewModel.startUpdatingLocation()
                    }
                    .onDisappear {
                        locationViewModel.stopUpdatingLocation()
                    }
                
                VStack {
                    if !directions.isEmpty {
                        Text("Route Name")
                            .font(.headline)
                            .padding(.bottom)
                        
                        ForEach(directions.indices, id: \.self) { index in
                            DirectionStepView(stepNumber: index + 1, instruction: directions[index], isActive: index == stepIndex)
                                .onTapGesture {
                                    stepIndex = index
                                }
                        }
                    } else {
                        Text("Directions not available")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        updateStepIndex(forward: false)
                    }) {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(stepIndex == 0 ? Color.gray.opacity(0.5) : Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .disabled(stepIndex == 0)
                    
                    Spacer()
                    
                    Text("Step \(stepIndex + 1) of \(directions.count)")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        updateStepIndex(forward: true)
                    }) {
                        Image(systemName: "chevron.right")
                            .padding()
                            .background(stepIndex == directions.count - 1 ? Color.gray.opacity(0.5) : Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .disabled(stepIndex == directions.count - 1)
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    openUberWithCoordinates()
                }) {
                    Text("Order Uber")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .navigationBarTitle("Order Details", displayMode: .inline)
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
                    }
                }
            } else {
                print("Document does not exist")
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
    
    private func updateStepIndex(forward: Bool) {
        if forward {
            if stepIndex < directions.count - 1 {
                stepIndex += 1
            }
        } else {
            if stepIndex > 0 {
                stepIndex -= 1
            }
        }
    }
}

struct MapViewer: UIViewRepresentable {
    @Binding var userLocation: CLLocationCoordinate2D
    let pickupLocation: CLLocationCoordinate2D
    @Binding var route: MKRoute?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = userLocation
        userAnnotation.title = "Your Location"
        
        let pickupAnnotation = MKPointAnnotation()
        pickupAnnotation.coordinate = pickupLocation
        pickupAnnotation.title = "Pickup Point"
        
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(userAnnotation)
        uiView.addAnnotation(pickupAnnotation)
        
        if let route = route {
            uiView.addOverlay(route.polyline)
            
            // Zoom to user's location when the directions start
            if !route.steps.isEmpty {
                let firstStep = route.steps.first!
                let region = MKCoordinateRegion(center: firstStep.polyline.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                uiView.setRegion(region, animated: true)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewer
        
        init(_ parent: MapViewer) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 6
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}

struct DirectionStepView: View {
    let stepNumber: Int
    let instruction: String
    let isActive: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(isActive ? Color.blue : Color.gray)
                .frame(width: 10, height: 10)
                .padding(.leading, 5)
            
            Text(instruction)
                .font(.body)
            
            Spacer()
        }
        .padding(.vertical, 5)
        .background(isActive ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(5)
    }
}

struct OrderPageView_Previews: PreviewProvider {
    static var previews: some View {
        OrderPageView(userCurrentLocation: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                      userPickup: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    }
}

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var userLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last?.coordinate else { return }
        userLocation = location
    }
}

