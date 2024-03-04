//
//  SavedAddressView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct SavedAddressView: View {
    @StateObject var viewModel = AddressBookViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                // "Add Saved Place" button
                NavigationLink(destination: AddSavedAddress()) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Add Saved Place")
                                .foregroundColor(.blue)
                            Text("Get to your favorite destination faster")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                ForEach(viewModel.addresses) { address in
                    NavigationLink(destination: EditSavedPlace(address: address)) {
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
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Choose a Place")
            .onAppear() {
                self.viewModel.fetchData()
            }
        }
        
    }
}

#Preview {
    SavedAddressView()
}
