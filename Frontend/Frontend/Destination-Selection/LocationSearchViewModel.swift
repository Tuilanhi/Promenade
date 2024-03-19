//
//  LocationSearchViewModel.swift
//  Frontend
//
//  Created by James Stautler on 3/3/24.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    // Properties
    @Published var destinationResults = [MKLocalSearchCompletion]()
    @Published var currentLocationResults = [MKLocalSearchCompletion]()
    @Published var selectedDestination: String?
    @Published var selectedCurrentLocation: String?
    
    private let destinationSearchCompleter = MKLocalSearchCompleter()
    private let currentLocationSearchCompleter = MKLocalSearchCompleter()
    
    @Published var selectionComplete: Bool = false
    @Published var savedAddressSelected: Bool = false
    
    @Published var currentLocationQuery: String = "" {
        didSet {
            currentLocationSearchCompleter.queryFragment = currentLocationQuery
        }
    }
    
    @Published var destinationQuery: String = "" {
        didSet {
            destinationSearchCompleter.queryFragment = destinationQuery
        }
    }
    
    override init() {
        super.init()
        destinationSearchCompleter.delegate = self
        currentLocationSearchCompleter.delegate = self
    }
    
    // Helper functions
    
    func selectDestination(_ location: String) {
        self.selectedDestination = location
        self.selectionComplete = true
    }
    
    func selectCurrentLocation(_ location: String) {
        self.selectedCurrentLocation = location
        // Immediately hide the address list by setting selectionComplete to true
        self.selectionComplete = true
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        if completer == destinationSearchCompleter {
            self.destinationResults = completer.results
        } else if completer == currentLocationSearchCompleter {
            self.currentLocationResults = completer.results
        }
    }
}
