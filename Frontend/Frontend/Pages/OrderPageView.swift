//
//  OrderPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit

struct OrderPageView: View {
    // State variable to hold the map region
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 30.613, longitude: -96.342), // Example coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var address: String = "161 Wellborn Rd"
    
    var body: some View {

            
        VStack {
            MapView(region: $region)
                .frame(height: UIScreen.main.bounds.height * 0.50)
                .edgesIgnoringSafeArea(.top)

           
                
            HStack {
               
                VStack(alignment: .leading, spacing: 5) {
                    Text("\u{2022} Go straight")
                    Text("\u{2022} Turn Right")
                }
            }
        
            Spacer()
            
            Button(action: {}) {
                Text("Order Uber")
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
    OrderPageView()
}
