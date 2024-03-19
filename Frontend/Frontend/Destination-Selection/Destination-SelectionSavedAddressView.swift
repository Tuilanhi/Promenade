//
//  Destination-SelectionSavedAddressView.swift
//  Frontend
//
//  Created by Nhi Vu on 3/14/24.
//

import SwiftUI

struct Destination_SelectionSavedAddressView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = AddressBookViewModel()
    @State private var navigateToRideSelection = false
    var onSelectAddress: (String) -> Void

    var body: some View {
        List {
            ForEach(viewModel.addresses) { address in
                Button(action: {
                    self.onSelectAddress(address.address)
                    /*navigateToRideSelection = true*/ // Trigger navigation when an address is tapped
                    self.dismiss()
                }) {
                    HStack {
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        VStack(alignment: .leading) {
                            Text(address.name)
                                .foregroundColor(.black)
                            Text(address.address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle()) // Use this to retain the list's default tap feedback
            }
        }
        .listStyle(GroupedListStyle())
        .onAppear() {
            viewModel.fetchData()
        }
//        .navigationDestination(isPresented: $navigateToRideSelection) {
//            RideSelectionView()
//        }
    }
}

//#Preview {
//    Destination_SelectionSavedAddressView()
//}

