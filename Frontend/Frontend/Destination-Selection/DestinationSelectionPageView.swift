//
//  DestinationSelectionView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI
import UIKit

struct DestinationSelectionPageView: View {
    @StateObject var viewModel = LocationSearchViewModel()
    @State private var navigateToRideSelection = false
    
    @State private var isCurrentLocationActive = false

    var body: some View {
        NavigationStack {
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
                        TextField("Current Location", text: $viewModel.currentLocationQuery)
                            .onTapGesture {
                                self.isCurrentLocationActive = true
                            }
                            .frame(height: 32)
                            .background(Color(.systemGroupedBackground))
                            .padding(.trailing)
                            .padding(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                        TextField("Destination", text: $viewModel.destinationQuery)
                            .onTapGesture {
                                self.isCurrentLocationActive = false
                            }
                            .frame(height: 32)
                            .background(Color(.systemGray4))
                            .padding(.trailing)
                            .padding(.leading)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                        
                        
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                Divider()
                    .padding(.vertical)
                
                // Navigation Link to SavedAddressView
                NavigationLink(destination: Destination_SelectionSavedAddressView()) {
                    HStack {
                        Image(systemName: "star.fill") // Use your house icon here
                            .foregroundColor(.black)
                        VStack(alignment: .leading) {
                            Text("Saved Address")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        if isCurrentLocationActive{
                            ForEach(viewModel.currentLocationResults, id: \.self) { result in
                                DestinationSelectionResultCell(title: result.title,
                                                               subtitle: result.subtitle)
                                .onTapGesture {
                                    self.viewModel.currentLocationQuery = result.title
                                    self.viewModel.selectCurrentLocation(result.title)
                                    
                                }
                            }
                        }
                        else
                        {
                            ForEach(viewModel.destinationResults, id: \.self) { result in
                                DestinationSelectionResultCell(title: result.title,
                                                               subtitle: result.subtitle)
                                .onTapGesture {
                                    self.viewModel.destinationQuery = result.title
                                    self.navigateToRideSelection = true
                                }
                            }
                        }
                    }
                    .navigationDestination(isPresented: $navigateToRideSelection) {
                        RideSelectionView()
                    }
                }
            }
            .navigationTitle("Search a Place")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DestinationSelectionPageView()
}
