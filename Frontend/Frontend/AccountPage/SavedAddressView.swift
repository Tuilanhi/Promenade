//
//  SavedAddressView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct SavedAddressView: View {
    @ObservedObject var viewModel = AddressBookViewModel()
    @Environment(\.editMode) var editMode // To control the edit mode
    
    var body: some View {
        NavigationView {
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
                .onDelete(perform: viewModel.deleteAddress)
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Choose a Place")
            .onAppear() {
                self.viewModel.fetchData()
            }
            .navigationBarItems(trailing: EditButton()) // Add an Edit button
        }
    }
}

#Preview {
    SavedAddressView()
}
