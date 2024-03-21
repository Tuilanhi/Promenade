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
    @State private var selectedRouteId: Int?
    @State private var dragOffset = CGSize.zero
    @State private var routeOptions: [RouteOption] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                MapView()
                VStack {
                    Capsule()
                        .foregroundColor(Color(.systemGray5))
                        .frame(width: 48, height: 6)
                
                    VStack {
                        routeSelection
                        Divider().padding(.vertical, 8)
                        confirmButton
                    }
                }
                .background(.white)
            }
            .onAppear {
                loadRouteOptions()
            }
        }
    }
    
    func loadRouteOptions() {
        let jsonData = """
        {
          "rides": [
            {
              "source": {
                "lat": 30.629979658501668,
                "long": -96.3324372242465
              },
              "pickupPoint": {
                "lat": 30.6213803,
                "long": -96.340158
              },
              "destination": {
                "lat": 30.6231958,
                "long": -96.3285208
              },
              "walkTime": 1044,
              "walkDistance": 0.9003665790000001,
              "driveTime": 271,
              "driveDistance": 0.720168989,
              "totalTime": 1315,
              "totalDistance": 1.6205355680000002,
              "price": 10.854228
            },
            {
              "source": {
                "lat": 30.62178035739474,
                "long": -96.33854449199474
              },
              "pickupPoint": {
                "lat": 30.6213803,
                "long": -96.340158
              },
              "destination": {
                "lat": 30.6231958,
                "long": -96.3285208
              },
              "walkTime": 120,
              "walkDistance": 0.103768957,
              "driveTime": 296,
              "driveDistance": 0.893531498,
              "totalTime": 416,
              "totalDistance": 0.997300455,
              "price": 11.031393
            },
            {
              "source": {
                "lat": 30.62170959960276,
                "long": -96.34179274951764
              },
              "pickupPoint": {
                "lat": 30.6213803,
                "long": -96.340158
              },
              "destination": {
                "lat": 30.6231958,
                "long": -96.3285208
              },
              "walkTime": 209,
              "walkDistance": 0.18019759,
              "driveTime": 324,
              "driveDistance": 1.166313367,
              "totalTime": 533,
              "totalDistance": 1.346510957,
              "price": 11.2584305
            }
          ]
        }
        """.data(using: .utf8)!
        
        routeOptions = parseRideOptions(from: jsonData)
        routeOptions = assignIconsToRouteOptions(routeOptions)
        if let figureWalkIndex = routeOptions.firstIndex(where: { $0.iconName == "hare.fill" }) {
                    selectedRouteId = routeOptions[figureWalkIndex].id
                }
        self.routeOptions = routeOptions
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
                    
                    Text(Date().formattedTime())
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 10)
                
                HStack {
                    Text("Destination")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    if let selectedRoute = routeOptions.first(where: { $0.id == selectedRouteId }) {
                        Text("\(selectedRoute.formattedDestinationTime)")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                    }
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
            
            VStack(spacing: 12) {
                ForEach(routeOptions) { option in
                    Button(action: {
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
    
    private var confirmButton: some View {
        Button {
            self.navigateToConfirmPage = true
        } label: {
            Text("CONFIRM ROUTE")
                .fontWeight(.bold)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
        }
        .padding(.vertical)
        .navigationDestination(isPresented: $navigateToConfirmPage) {
            if let selectedRouteId = selectedRouteId,
               let selectedRoute = routeOptions.first(where: { $0.id == selectedRouteId }) {
                ConfirmPageView(currentTime: Date().formattedTime(), destinationTime: selectedRoute.formattedDestinationTime)
            } else {
                // Fallback or error handling if no route is selected
                Text("No route selected")
            }
        }
    }
    
    struct OptionView: View {
        let option: RouteOption

        var body: some View {
            HStack {
                Image(systemName: option.iconName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .frame(width: 60)

                VStack(alignment: .leading) {
                    HStack {
                        Text(option.formattedWalkTime)
                            .fontWeight(.bold)
                        Text("•")
                        Text(option.formattedWalkDistance)
                            .fontWeight(.bold)
                        Spacer()
                        Text(option.formattedPrice)
                            .fontWeight(.bold)
                    }
                    Text("Arrive by: \(option.formattedDestinationTime)")
                        .fontWeight(.regular)
                }
                Spacer()
            }
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
            .cornerRadius(10)
        }
    }
}

extension Date {
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}


#Preview {
    RideSelectionView()
}
