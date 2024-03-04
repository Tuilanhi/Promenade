//
//  DestinationSelectionView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import UIKit

struct DestinationSelectionPageView: View {
    @State private var startLocation = ""
    @State private var destinationLocation = ""
    var body: some View {
        VStack(alignment: .leading) {
            // Header (text field) view
            HStack {
                VStack {
                    Circle()
                        .fill(Color(.systemGray3))
                        .frame(width: 6, height: 6)
                    
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 24)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 6, height: 6)
                }
                VStack {
                    TextField("Current Location", text:$startLocation)
                        .frame(height: 32)
                        .background(Color(.systemGroupedBackground))
                        .padding(.trailing)
                        .padding(.leading)
                    
                    TextField("Destination", text:$destinationLocation)
                        .frame(height: 32)
                        .background(Color(.systemGray4))
                        .padding(.trailing)
                        .padding(.leading)

                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
                .padding(.vertical)
    
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0 ..< 20, id: \.self) { _ in
                        DestinationSelectionResultCell()
                    }
                }
            }
        }
        .navigationBarTitle("Select Destination", displayMode: .inline)
    }
}

#Preview {
    DestinationSelectionPageView()
}
