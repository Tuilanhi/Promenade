//
//  HomePageView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import MapKit

struct HomePageView: View {
    var body: some View {
        VStack {
            SearchBarView()
            
            MapView()
        }
    }
}

#Preview {
    HomePageView()
}
