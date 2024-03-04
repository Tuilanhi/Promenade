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
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocation: String?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // Helper functions
    
    func selectLocation(_ location: String) {
        self.selectedLocation = location
    }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
