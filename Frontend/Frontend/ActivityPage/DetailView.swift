//
//  DetailView.swift
//  Frontend
//
//  Created by Nhi Vu on 3/31/24.
//

import Foundation
import SwiftUI

struct DetailView: View {
    var activity: Activity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Spacer().frame(height: 20)
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.currentDate + " " + activity.currentTime)
                        .foregroundColor(.secondary)
                    Text("$\(String(format: "%.2f", activity.price))")
                        .font(.title2)
                    Text("\(String(format: "%.1f mi", activity.walkDistance))" + " • " + "\(activity.walkTime / 60) min")
                        .foregroundColor(.secondary)

                    Spacer().frame(height: 20)

                    Text("Source Address")
                        .font(.headline)
                    Text(activity.pickupPointAddress)
                        .font(.subheadline)

                    Spacer().frame(height: 20)

                    Text("Pickup Address")
                        .font(.headline)
                    Text(activity.sourceAddress)
                        .font(.subheadline)

                    Spacer().frame(height: 20)

                    Text("Destination Address")
                        .font(.headline)
                    Text(activity.destinationAddress)
                        .font(.subheadline)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Walking Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

