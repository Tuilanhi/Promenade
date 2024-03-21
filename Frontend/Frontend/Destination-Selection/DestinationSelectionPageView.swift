//
//  DestinationSelectionView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import UIKit
import CoreLocation

struct DestinationSelectionPageView: View {
    @StateObject var viewModel = LocationSearchViewModel()
    @StateObject private var locationManager = LocationManager()
    @State private var navigateToRideSelection = false
    @State private var isCurrentLocationActive = false
    @State private var isDestinationActive = false
    
    @State private var sourceCoordinates = CLLocationCoordinate2D(latitude: 30.942052, longitude: -94.125397)
    @State private var destinationCoordinates = CLLocationCoordinate2D(latitude: 31.124356, longitude: -93.234586)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
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
                            .onTapGesture {
                                self.isCurrentLocationActive = true
                                self.viewModel.savedAddressSelected = false
                            }
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))
                            .padding(.trailing)
                            .padding(.leading)
                            .disableAutocorrection(true)
                        
                        TextField("Destination", text: $viewModel.destinationQuery)
                            .onTapGesture {
                                self.isCurrentLocationActive = false
                                self.isDestinationActive = true
                            }
                            .frame(height: 32)
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
                        navigateToRideSelection = true
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
                                    if (viewModel.selectionComplete) {
                                        self.navigateToRideSelection = true
                                    }
                                    geocodeAddressString(result.subtitle)
                                }
                            }
                        }
                    }
                    .navigationDestination(isPresented: $navigateToRideSelection) {
                        RideSelectionView($sourceCoordinates, $destinationCoordinates)
                    }
                }
            }
            .navigationTitle("Search a Place")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                locationManager.setup()
                updateLocationQuery(initial: true)
            }
            .onChange(of: locationManager.userLocation) {
                updateLocationQuery()
            }
        }
    }
    
    private func updateLocationQuery(initial: Bool = false) {
        if viewModel.savedAddressSelected {
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
            let formattedAddress = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality].compactMap { $0 }.joined(separator: ", ")
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
                if self.isDestinationActive {
                    self.destinationCoordinates = location.coordinate
                    self.navigateToRideSelection = true
                    self.printLocationJSON()
                }
            } else {
                self.destinationCoordinates = location.coordinate
                self.navigateToRideSelection = true
                self.printLocationJSON()
            }
        }
    }
    
    private func printLocationJSON() {
        let jsonOutput = """
        {
          "source": {
            "lat": \(sourceCoordinates.latitude),
            "long": \(sourceCoordinates.longitude)
          },
          "destination": {
            "lat": \(destinationCoordinates.latitude),
            "long": \(destinationCoordinates.longitude)
          },
        "maxPoints": 3
        }
        """
        print(jsonOutput)
    }
}

#Preview {
    DestinationSelectionPageView()
}
