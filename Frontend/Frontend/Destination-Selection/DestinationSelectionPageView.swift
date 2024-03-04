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
    @StateObject var viewModel = LocationSearchViewModel()
    
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
                    
                    TextField("Destination", text:$viewModel.queryFragment)
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
                    ForEach(viewModel.results, id: \.self) { result in
                        DestinationSelectionResultCell(title: result.title,
                            subtitle: result.subtitle)
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
