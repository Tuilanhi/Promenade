//
//  ConfirmPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit

struct ConfirmPageView: View {
    // State variable to hold the map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.613, longitude: -96.342), // Example coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var address: String = "161 Wellborn Rd"
    
    var body: some View {

            
        VStack {
            MapView(region: $region)
                .frame(height: UIScreen.main.bounds.height * 0.70)
                .edgesIgnoringSafeArea(.top)

            Text("Confirm Pickup Spot")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 0)
                
         
            Divider()
        
            HStack {
                Spacer()
                Text("Address: \(address)")
                Spacer()
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .padding()
                        .foregroundColor(Color.white)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                Spacer()
            }
        
            Spacer()
            
            Button(action: {}) {
                Text("Confirm")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.black)
                    .cornerRadius(10)
            }
      
        }
    }
}

#Preview {
    ConfirmPageView()
}
