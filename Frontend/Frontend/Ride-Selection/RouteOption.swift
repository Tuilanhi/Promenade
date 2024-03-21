//
//  RouteOption.swift
//  Frontend
//
//  Created by Nhi Vu on 3/14/24.
//

import Foundation

struct RouteOption: Identifiable {
    let id: Int
    let walkTime: Int
    let walkDistance: Double
    let price: Double
    var iconName: String
    let destinationTime: Date
    
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
}
