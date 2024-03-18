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
    @State private var selectedRouteId: Int? = 1
    // Drag featur
    @State private var dragOffset = CGSize.zero
    
    let routeOptions: [RouteOption] = [
        RouteOption(id: 0, title: "Fastest", distance: "0.8 miles", price: "$12.00", iconName: "hare.fill"),
        RouteOption(id: 1, title: "Recommended", distance: "1.2 miles", price: "$17.50", iconName: "figure.walk"),
        RouteOption(id: 2, title: "Eco", distance: "1.5 miles", price: "$29.00", iconName: "tortoise.fill"),
        RouteOption(id: 3, title: "Other", distance: "1.4 miles", price: "$27.00", iconName: "figure")
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                MapView()
                VStack {
                    Capsule()
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 48, height: 6)
                
                    VStack {
                        tripInformation
                        Divider()
                        routeSelection
                        Divider().padding(.vertical, 8)
                        confirmButton
                    }
                }
                .background(.white)
            }
        }
    }
    
    private var tripInformation: some View {
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
    }
    
    private var routeSelection: some View {
        VStack {
            Text("Suggested Routes")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(routeOptions) { option in
                        Button(action: {
                            // Toggle selection state
                            selectedRouteId = option.id
                        }) {
                            OptionView(option: option)
                                .background(selectedRouteId == option.id ? Color.blue.opacity(0.3) : Color(.systemGroupedBackground))
                                .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }


    
    private var confirmButton: some View {
        Button {
            self.navigateToConfirmPage = true
        } label: {
            Text("CONFIRM ROUTE")
                .fontWeight(.bold)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                .background(Color.blue) // Change color based on selection
                .cornerRadius(10)
                .foregroundColor(.white)
        }
        .padding(.vertical)
        .navigationDestination(isPresented: $navigateToConfirmPage) {
            ConfirmPageView()
        }
    }
    
    struct OptionView: View {
        let option: RouteOption

        var body: some View {
            VStack {
                Image(systemName: option.iconName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                Text(option.title)
                    .fontWeight(.semibold)
                
                Text(option.distance)
                    .foregroundColor(.gray)
                
                Text(option.price)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(width: 112, height: 150)
            .cornerRadius(10)
        }
    }
}

#Preview {
    RideSelectionView()
}
