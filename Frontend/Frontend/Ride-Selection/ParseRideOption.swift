//
//  ParseRideOption.swift
//  Frontend
//
//  Created by Nhi Vu on 3/21/24.
//

import Foundation
// Represents a single ride option in the JSON.
struct Ride: Decodable {
    let walkTime: Int
    let walkDistance: Double
    let driveTime: Int
    let driveDistance: Double
    let totalTime: Int
    let totalDistance: Double
    let price: Double
}

// Container for the JSON structure
struct RideOptionsContainer: Decodable {
    let rides: [Ride]
}

func assignIconsToRouteOptions(_ routeOptions: [RouteOption]) -> [RouteOption] {
    let sortedOptions = routeOptions.sorted(by: { $0.walkTime < $1.walkTime })
    return sortedOptions.enumerated().map { index, option in
        var modifiedOption = option
        switch index {
            case 0:
                modifiedOption.iconName = "hare.fill"
            case sortedOptions.count - 1:
                modifiedOption.iconName = "tortoise.fill"
            default:
                modifiedOption.iconName = "figure.walk"
        }
        return modifiedOption
    }
}


func parseRideOptions(from jsonData: Data) -> [RouteOption] {
    let decoder = JSONDecoder()
    do {
        let container = try decoder.decode(RideOptionsContainer.self, from: jsonData)
        var routeOptions = container.rides.enumerated().map { index, ride in
            let iconName = "figure.walk"
            
            let destinationTime = Calendar.current.date(byAdding: .second, value: ride.walkTime, to: Date())!
            
            // Use index as id for simplicity
            return RouteOption(
                id: index,
                walkTime: ride.walkTime,
                walkDistance: ride.walkDistance,
                price: ride.price,
                iconName: iconName, // This will be adjusted in the next step
                destinationTime: destinationTime
            )
        }
        routeOptions = assignIconsToRouteOptions(routeOptions)
        return routeOptions
    } catch {
        print("Error decoding JSON: \(error)")
        return []
    }
}


