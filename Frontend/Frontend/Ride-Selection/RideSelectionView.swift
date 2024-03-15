//
//  RideSelectionView.swift
//  Frontend
//
//  Created by James Stautler on 2/27/24.
//

import SwiftUI
import MapKit

struct RideSelectionView: View {
    @State var navigateToConfirmPage = false
    @State private var selectedRouteId: Int? = nil
    @StateObject var manager = LocationManager()
    
    let routeOptions: [RouteOption] = [
        RouteOption(id: 0, title: "Fastest", distance: "0.8 miles", price: "$12.00", iconName: "hare.fill"),
        RouteOption(id: 1, title: "Recommended", distance: "1.2 miles", price: "$17.50", iconName: "figure.walk"),
        RouteOption(id: 2, title: "Eco", distance: "1.5 miles", price: "$29.00", iconName: "tortoise.fill")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Map(position: $manager.region)
                {
                
                }
                Capsule()
                    .foregroundColor(Color(.systemGray5))
                    .frame(width: 48, height: 6)
                // Trip Information
                HStack {
                    VStack {
                        Circle()
                            .fill(Color(.systemGray3))
                            .frame(width: 8, height: 8)
                        
                        Rectangle()
                            .fill(Color(.systemGray3))
                            .frame(width: 1, height: 32)
                        
                        Rectangle()
                            .fill(.black)
                            .frame(width: 8, height: 8)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Current Location")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("1:30 PM")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 10)
                        
                        HStack {
                            Text("Destination")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Spacer()
                            
                            Text("1:45 PM")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding()
                
                Divider()
                
                // Route Selection
                Text("Suggested Routes")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding()
                    .foregroundColor(Color.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 12) {
                    ForEach(routeOptions) { option in
                        Button(action: {
                            // Toggle selection state
                            selectedRouteId = option.id
                        }) {
                            VStack {
                                Image(systemName: option.iconName)
                                    .font(.largeTitle)
                                    .foregroundColor(selectedRouteId == option.id ? .blue : .black)
                                
                                Text(option.title)
                                    .fontWeight(.semibold)
                                
                                Text(option.distance)
                                    .foregroundColor(.gray)
                                
                                Text(option.price)
                                    .fontWeight(.semibold)
                            }
                            .padding()
                            .frame(width: 112, height: 150)
                            .background(selectedRouteId == option.id ? Color(.systemBlue).opacity(0.2) : Color(.systemGroupedBackground))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical, 8)
                
                Button {
                    self.navigateToConfirmPage = true
                } label: {
                    Text("CONFIRM ROUTE")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .background(selectedRouteId != nil ? Color.blue : Color.gray) // Change color based on selection
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .disabled(selectedRouteId == nil) // Disable the button if no route is selected
                .padding(.vertical)
                .navigationDestination(isPresented: $navigateToConfirmPage) {
                    ConfirmPageView()
                }
            }
            .background(.white)
        }
    }
}

#Preview {
    RideSelectionView()
}
