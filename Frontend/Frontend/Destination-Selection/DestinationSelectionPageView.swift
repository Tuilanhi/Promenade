//
//  DestinationSelectionView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import UIKit
import CoreLocation
import Firebase

struct DestinationSelectionPageView: View {
    @StateObject var viewModel = LocationSearchViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var navigateToRideSelection = false
    @State private var isCurrentLocationActive = false
    @State private var isDestinationActive = false
    @FocusState private var isCurrentLocationFieldFocused: Bool
    
    @State private var sourceCoordinates = CLLocationCoordinate2D(latitude: 30.942052, longitude: -94.125397)
    @State private var destinationCoordinates = CLLocationCoordinate2D(latitude: 31.124356, longitude: -93.234586)

    @State private var showLoadingScreen = false
    @FocusState private var isDestinationFocused: Bool
    
    // Fetch the userId from Firebase Authentication
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if showLoadingScreen {
                    // Loading screen
                    GIFImageView(imageName: "logo")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(1))
                            .transition(.opacity)
                    
                }
                else
                {
                    HStack {
                        VStack {
                            Circle()
                                .fill(Color(.systemGray3))
                                .frame(width: 6, height: 6)
                            
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(width: 1, height: 24)
                            
                            Rectangle()
                                .fill(.black)
                                .frame(width: 6, height: 6)
                        }
                        VStack {
                            TextField("Current Location", text: $viewModel.currentLocationQuery)
                                .focused($isCurrentLocationFieldFocused)
                                .onChange(of: viewModel.currentLocationQuery) { oldValue, newValue in
                                    viewModel.userClearedCurrentLocation = newValue.isEmpty
                                    if newValue.isEmpty {
                                        viewModel.allowAutomaticLocationUpdate = false
                                    }
                                }
                                .onSubmit {
                                    if isCurrentLocationActive {
                                        viewModel.allowAutomaticLocationUpdate = true
                                        updateLocationQuery()
                                    }
                                }
                                .onTapGesture {
                                    self.isCurrentLocationActive = true
                                    self.isDestinationActive = false
                                    viewModel.savedAddressSelected = false
                                    viewModel.allowAutomaticLocationUpdate = false
                                }
                                .frame(height: 38)
                                .background(Color(.systemGroupedBackground))
                                .padding(.trailing)
                                .padding(.leading)
                                .disableAutocorrection(true)
                            
                            TextField("Destination", text: $viewModel.destinationQuery)
                                .focused($isDestinationFocused)
                                .onTapGesture {
                                    self.isCurrentLocationActive = false
                                    self.isDestinationActive = true
                                }
                                .frame(height: 38)
                                .background(Color(.systemGray4))
                                .padding(.trailing)
                                .padding(.leading)
                                .disableAutocorrection(true)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    Divider()
                        .padding(.vertical)
                    
                    // Navigation Link to SavedAddressView
                    NavigationLink(destination: Destination_SelectionSavedAddressView(onSelectAddress: { selectedAddress in
                        if isCurrentLocationActive{
                            viewModel.currentLocationQuery = selectedAddress
                            isCurrentLocationActive = false
                        }else
                        {
                            viewModel.destinationQuery = selectedAddress
                            isDestinationActive = false
                        }
                        viewModel.savedAddressSelected = true
                    }))  {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.black)
                            VStack(alignment: .leading) {
                                Text("Saved Address")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            if isCurrentLocationActive{
                                ForEach(viewModel.currentLocationResults, id: \.self) { result in
                                    DestinationSelectionResultCell(title: result.title,
                                                                   subtitle: result.subtitle)
                                    .onTapGesture {
                                        self.viewModel.currentLocationQuery = result.title
                                        self.viewModel.selectCurrentLocation(result.title)
                                        geocodeAddressString(result.subtitle)
                                    }
                                }
                            }
                            else
                            {
                                ForEach(viewModel.destinationResults, id: \.self) { result in
                                    DestinationSelectionResultCell(title: result.title,
                                                                   subtitle: result.subtitle)
                                    .onTapGesture {
                                        self.viewModel.destinationQuery = result.title
                                        geocodeAddressString(result.subtitle)
                                    }
                                }
                            }
                        }
                        .navigationDestination(isPresented: $navigateToRideSelection) {
                            RideSelectionView()
                        }
                    }
                }
            }
            .navigationTitle("Search a Place")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                locationManager.setup()
                updateLocationQuery(initial: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isDestinationFocused = true
                }
            }
            .onChange(of: locationManager.userLocation) {
                if viewModel.allowAutomaticLocationUpdate {
                    updateLocationQuery()
                }
            }
        }
    }
    
    private func updateLocationQuery(initial: Bool = false) {
        if !viewModel.allowAutomaticLocationUpdate || viewModel.userClearedCurrentLocation {
            return
        }
        
        guard let location = locationManager.userLocation else {
            if initial {
                locationManager.setup()
            }
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak viewModel] placemarks, error in
            guard let placemark = placemarks?.first else { return }
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let streetAddress = streetNumber.isEmpty ? streetName : "\(streetNumber) \(streetName)"
            
            let formattedAddress = [streetAddress, placemark.locality].compactMap { $0 }.joined(separator: ", ")
            viewModel?.currentLocationQuery = formattedAddress
            self.sourceCoordinates = location.coordinate
        }
    }
    
    private func geocodeAddressString(_ addressString: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else { return }
            
            if self.isCurrentLocationActive {
                self.sourceCoordinates = location.coordinate
            } else {
                self.destinationCoordinates = location.coordinate
                guard let userId = self.userId else {
                    print("Error: User is not authenticated.")
                    return
                }
                Task {
                    await self.fetchDataFromAPI(userId: userId)
                }
            }
        }
    }
}

extension DestinationSelectionPageView {
    func fetchDataFromAPI(userId: String) async {
        showLoadingScreen = true // Activate loading screen

        guard let url = URL(string: "https://lpr6uss943.execute-api.us-east-1.amazonaws.com/dev/street-exploration") else {
            print("Invalid URL string.")
            DispatchQueue.main.async {
                self.showLoadingScreen = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonBody: [String: Any] = [
            "source": [
                "lat": sourceCoordinates.latitude,
                "long": sourceCoordinates.longitude
            ],
            "destination": [
                "lat": destinationCoordinates.latitude,
                "long": destinationCoordinates.longitude
            ],
            "maxPoints": 3
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            guard let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Failed to parse JSON or incorrect format")
                DispatchQueue.main.async {
                    self.showLoadingScreen = false
                }
                return
            }
            
            // Create a unique document path for suggested-routes using the userId
            let firestore = Firestore.firestore()
            let userDocumentRef = firestore.collection("users").document(userId)
            let collectionRef = userDocumentRef.collection("suggested-routes")
            
            // Clear existing documents in suggested-routes for the user
            let documents = try await collectionRef.getDocuments().documents
            for document in documents {
                try await collectionRef.document(document.documentID).delete()
            }
            
            // Add new data to the suggested-routes collection
            guard let rides = jsonResponse["rides"] as? [[String: Any]] else {
                print("Data format error: 'rides' not found.")
                DispatchQueue.main.async {
                    self.showLoadingScreen = false
                }
                return
            }
            
            for ride in rides {
                _ = try await collectionRef.addDocument(data: ride)
            }
            
            DispatchQueue.main.async {
                self.navigateToRideSelection = true
                self.showLoadingScreen = false
            }
        } catch {
            print("Error during URLSession or JSON parsing: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.showLoadingScreen = false
            }
        }
    }
    
    func clearAndUpdateSuggestedRoutes(with data: [String: Any]) async {
        guard let userId = self.userId else {
            print("Error: User is not authenticated.")
            return
        }
        let firestore = Firestore.firestore()
        let userDocumentRef = firestore.collection("users").document(userId)
        let collectionRef = userDocumentRef.collection("suggested-routes")
        
        // Attempt to clear existing documents. This is optional and depends on your app's logic.
        // Since Firestore automatically creates a collection when adding a new document,
        // there's no need to explicitly create the "suggested-routes" collection.
        // The code below handles clearing existing documents gracefully,
        // even if the collection does not yet exist or is empty.
        do {
            let documents = try await collectionRef.getDocuments().documents
            for document in documents {
                try await collectionRef.document(document.documentID).delete()
            }
        } catch {
            print("Error clearing 'suggested-routes' collection: \(error.localizedDescription)")
            // You might decide to handle this error differently depending on your needs.
            // For example, if the collection doesn't exist yet, this error can be ignored.
        }
        
        // Proceed to add new data to the collection. This step effectively ensures
        // the collection exists by adding new documents to it.
        guard let rides = data["rides"] as? [[String: Any]] else {
            print("Data format error: 'rides' not found.")
            return
        }
        for ride in rides {
            do {
                _ = try await collectionRef.addDocument(data: ride)
            } catch {
                print("Error adding document to 'suggested-routes': \(error.localizedDescription)")
                // Handle or log the error as needed
            }
        }
        
        DispatchQueue.main.async {
            self.navigateToRideSelection = true
            self.showLoadingScreen = false
        }
    }
    
    func updateCurrentRouteInFirestore(currentRouteRef: DocumentReference, data: [String: Any]) async {
        do {
            try await currentRouteRef.setData(data)
            print("Current route updated successfully for the user.")
        } catch {
            print("Error updating current route for the user: \(error.localizedDescription)")
        }
    }
}

#Preview {
    DestinationSelectionPageView()
}
