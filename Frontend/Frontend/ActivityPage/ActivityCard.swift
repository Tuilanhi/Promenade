//
//  ActivityCard.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct Activity: Identifiable {
    let id = UUID()
    let finalDestination: String
    let date: String
    let price: Double
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
                
                Spacer()
                
                Button(action: {
                    // Action for the button "Rebook"
                }) {
                    HStack {
                        Image(systemName: "arrow.uturn.forward")
                        Text("Rebook")
                    }
                    .foregroundColor(.black)
                }
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
            .padding(.horizontal)
        }
    }
}
