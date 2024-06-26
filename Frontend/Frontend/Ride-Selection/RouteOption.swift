//
//  RouteOption.swift
//  Frontend
//
//  Created by Nhi Vu on 3/14/24.
//

import Foundation
import CoreLocation

struct RouteOption: Identifiable {
    var id: Int
    var iconName: String
    var walkTime: Int
    var walkDistance: Double
    var price: Double
    var destinationTime: Date
    var sourceCoordinate: CLLocationCoordinate2D
    var destinationCoordinate: CLLocationCoordinate2D
    var pickupPointCoordinate: CLLocationCoordinate2D
    var savings: Double
    
    // Convert walkTime in seconds to a formatted string (e.g., "12 min")
    var formattedWalkTime: String {
        "\(walkTime / 60) min walk"
    }

    // Format walkDistance to a string with 1 decimal place
    var formattedWalkDistance: String {
        String(format: "%.1f mi", walkDistance)
    }

    // Format price to a currency string
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
    
    var formattedDestinationTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: destinationTime)
    }
    
    var formattedSavings: String {
        String(format: "%.2f%%", savings)
    }
}

extension RouteOption {
    init(ride: Ride, id: Int) {
        self.id = id
        self.walkTime = ride.walkTime
        self.walkDistance = ride.walkDistance
        self.price = ride.price
        self.iconName = ""
        self.destinationTime = Date().addingTimeInterval(TimeInterval(walkTime))
        self.sourceCoordinate = CLLocationCoordinate2D(latitude: ride.source.lat, longitude: ride.source.long)
        self.destinationCoordinate = CLLocationCoordinate2D(latitude: ride.destination.lat, longitude: ride.destination.long)
        self.pickupPointCoordinate = CLLocationCoordinate2D(latitude: ride.pickupPoint.lat, longitude: ride.pickupPoint.long)
        self.savings = ride.savings
    }
}

