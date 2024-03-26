//
//  RideSelectionView.swift
//  Frontend
//
//  Created by James Stautler on 2/27/24.
//

import SwiftUI
import MapKit
import Firebase

struct RideSelectionView: View {
    @State var navigateToConfirmPage = false
    @State private var selectedRouteId: Int?
    @State private var routeOptions: [RouteOption] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                if let selectedRoute = routeOptions.first(where: { $0.id == selectedRouteId }) {
                    RouteView(sourceCoordinates: Binding.constant(selectedRoute.pickupPointCoordinate), destinationCoordinates: Binding.constant(selectedRoute.sourceCoordinate))
                    } else {
                    Text("Loading routes...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.5))
                        .transition(.opacity)
                }
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
        let db = Firestore.firestore()
        db.collection("suggested-routes")
          .order(by: "price", descending: false)
          .limit(to: 3)
          .getDocuments {(querySnapshot, err) in
              guard let documents = querySnapshot?.documents else {
                  print("Error fetching documents: \(err!)")
                  return
              }
              
              var tempRouteOptions = documents.compactMap { doc -> RouteOption? in
                  guard let ride = Ride(dictionary: doc.data()) else { return nil }
                  // Temporarily, initialize without setting iconName
                  return RouteOption(ride: ride, id: doc.documentID.hashValue)
              }.sorted(by: { $0.walkTime < $1.walkTime }) // Ensure the sorting is as required
              
              // Now, set iconName based on the position in the array
              for (index, _) in tempRouteOptions.enumerated() {
                  switch index {
                      case 0:
                          tempRouteOptions[index].iconName = "hare.fill"
                      case 1:
                          tempRouteOptions[index].iconName = "figure.walk"
                      case 2:
                          tempRouteOptions[index].iconName = "tortoise.fill"
                      default:
                          break
                  }
              }

              self.routeOptions = tempRouteOptions
              
              if let firstOption = tempRouteOptions.first {
                  self.selectedRouteId = firstOption.id
              }
          }
    }
    
    func iconNameForPrice(_ price: Double) -> String {
        // Example logic to determine icon name based on price. Adjust according to your actual criteria.
        switch price {
        case 0..<10:
            return "hare.fill"
        case 10..<20:
            return "figure.walk"
        default:
            return "tortoise.fill"
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


//#Preview {
//    RideSelectionView()
//}
