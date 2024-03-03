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
         
            Button(action: {}) {
                Text("Get Directions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
   
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

