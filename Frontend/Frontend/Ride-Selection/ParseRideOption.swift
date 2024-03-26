//
//  ParseRideOption.swift
//  Frontend
//
//  Created by Nhi Vu on 3/25/24.
//

import Foundation
import CoreLocation

// Represents a geographic location with latitude and longitude
struct Location: Codable {
    let lat: Double
    let long: Double
}

// Represents a single ride option
struct Ride: Decodable {
    let source: Location
    let pickupPoint: Location
    let destination: Location
    let walkTime: Int
    let walkDistance: Double
    let driveTime: Int
    let driveDistance: Double
    let totalTime: Int
    let totalDistance: Double
    let price: Double
    
    init?(dictionary: [String: Any]) {
        guard let sourceDict = dictionary["source"] as? [String: Double],
              let pickupPointDict = dictionary["pickupPoint"] as? [String: Double],
              let destinationDict = dictionary["destination"] as? [String: Double],
              let walkTime = dictionary["walkTime"] as? Int,
              let walkDistance = dictionary["walkDistance"] as? Double,
              let driveTime = dictionary["driveTime"] as? Int,
              let driveDistance = dictionary["driveDistance"] as? Double,
              let totalTime = dictionary["totalTime"] as? Int,
              let totalDistance = dictionary["totalDistance"] as? Double,
              let price = dictionary["price"] as? Double else {
            return nil
        }

        self.source = Location(lat: sourceDict["lat"]!, long: sourceDict["long"]!)
        self.pickupPoint = Location(lat: pickupPointDict["lat"]!, long: pickupPointDict["long"]!)
        self.destination = Location(lat: destinationDict["lat"]!, long: destinationDict["long"]!)
        self.walkTime = walkTime
        self.walkDistance = walkDistance
        self.driveTime = driveTime
        self.driveDistance = driveDistance
        self.totalTime = totalTime
        self.totalDistance = totalDistance
        self.price = price
    }
}

func parseRideOptions(from jsonData: Data) -> [RouteOption] {
    let decoder = JSONDecoder()
    do {
        let rides = try decoder.decode([Ride].self, from: jsonData)
        return rides.enumerated().map { index, ride in
            // Assuming destinationTime and iconName need to be derived or set explicitly
            RouteOption(
                id: index,
                iconName: "figure.walk",
                walkTime: ride.walkTime, // example default value
                walkDistance: ride.walkDistance,
                price: ride.price,
                destinationTime: Date(), // Convert or calculate as needed
                sourceCoordinate: CLLocationCoordinate2D(latitude: ride.source.lat, longitude: ride.source.long),
                destinationCoordinate: CLLocationCoordinate2D(latitude: ride.destination.lat, longitude: ride.destination.long),
                pickupPointCoordinate: CLLocationCoordinate2D(latitude: ride.pickupPoint.lat, longitude: ride.pickupPoint.long)
            )
        }
    } catch {
        print("Error decoding JSON: \(error)")
        return []
    }
}

