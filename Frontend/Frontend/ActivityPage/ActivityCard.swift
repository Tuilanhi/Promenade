//
//  ActivityCard.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI
import Foundation

struct Activity: Identifiable {
    var id: String
    let finalDestination: String
    let date: String
    let iconName: String
    let walkTime: Int
    let walkDistance: Double
    let price: Double
    let sourceAddress: String
    let destinationAddress: String
    let pickupPointAddress: String
    let currentTime: String
    let currentDate: String

    init(id: String, finalDestination: String, date: String, iconName: String, walkTime: Int, walkDistance: Double, price: Double, sourceAddress: String, destinationAddress: String, pickupPointAddress: String, currentTime: String, currentDate: String, pickupPointTitle: String) {
        self.id = id
        self.finalDestination = finalDestination
        self.date = date
        self.iconName = iconName
        self.walkTime = walkTime
        self.walkDistance = walkDistance
        self.price = price
        self.sourceAddress = sourceAddress
        self.destinationAddress = destinationAddress
        self.pickupPointAddress = pickupPointAddress
        self.currentTime = currentTime
        self.currentDate = currentDate
    }

    // Initialize from a Firestore document
    init?(documentId: String, data: [String: Any]) {
        guard let iconName = data["iconName"] as? String,
              let walkTime = data["walkTime"] as? Int,
              let walkDistance = data["walkDistance"] as? Double,
              let price = data["price"] as? Double,
              let sourceAddress = data["sourceAddress"] as? String,
              let destinationAddress = data["destinationAddress"] as? String,
              let pickupPointAddress = data["pickupPointAddress"] as? String,
              let currentTime = data["currentTime"] as? String,
              let currentDate = data["currentDate"] as? String,
              let pickupPointTitle = data["pickupPointTitle"] as? String else {
            return nil
        }

        self.id = documentId
        self.finalDestination = pickupPointTitle
        self.date = "\(currentDate) · \(currentTime)"
        self.iconName = iconName
        self.walkTime = walkTime
        self.walkDistance = walkDistance
        self.price = price
        self.sourceAddress = sourceAddress
        self.destinationAddress = destinationAddress
        self.pickupPointAddress = pickupPointAddress
        self.currentTime = currentTime
        self.currentDate = currentDate
    }
}


struct ActivityCard: View {
    var activity: Activity
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(systemName: "figure.walk")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.finalDestination)
                        .font(.headline)
                    Text(activity.date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("$\(String(format: "%.2f", activity.price))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
        }

    }
}
