//
//  OrderPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//
//

import SwiftUI
import MapKit

struct OrderPageView: View {
    
    var body: some View {

            
        VStack {
         
            Button(action: {
                if let url = URL(string: "https://maps.apple.com/?ll=30.613, -96.342") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Get Directions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
   
            Button(action: {
                if let url = URL(string: "https://www.uber.com/") {
                    UIApplication.shared.open(url)
                }
            }) {
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

