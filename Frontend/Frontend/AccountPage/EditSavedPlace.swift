//
//  EditSavedPlace.swift
//  Frontend
//
//  Created by nhi vu on 3/3/24.
//

import SwiftUI

struct EditSavedPlace: View {
    @StateObject var viewModel = AddressBookViewModel()
    var address: Address
    @State private var placeName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading){
                Divider()
                HStack {
                    Text("Name")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                }
                .padding(.bottom, 5)
                TextField("e.g. Ryan's Home", text: $placeName)
                    .padding(.leading, 16)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        ClearButton(text: $placeName)
                            .padding(.trailing)
                    }
                    .onAppear {
                        // Set initial value of placeName to address name
                        placeName = address.name
                    }
                    

                Divider()

                HStack {
                    Text("Address")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                }
                .padding(.bottom, 5)
                Text(address.address)
                    .padding(.leading, 16)
                    .padding(.bottom, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Gray background section
                Color.gray.opacity(0.2) // Adjust opacity as needed
                    .frame(height: 40) // Adjust height as needed
                    .padding(.vertical, 5) // Add some padding to give it some space

                
                Button(action: {
                    viewModel.deleteAddressById(address.id) {
                        // Assuming your delete function now has a completion handler
                        presentationMode.wrappedValue.dismiss() // Dismiss the view
                    }
                }) {
                    Text("Delete")
                        .foregroundColor(.red)
                        .padding(.leading, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle()) // Make sure the button doesn't apply any default styling
                
                // Gray background section between Delete and Save button
                Color.gray.opacity(0.2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 5)

                Spacer()

                

                Button(action: {
                    // Handle saving to Firebase here
                    viewModel.savePlace(name: placeName, address: address.address, id: address.id)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Place")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(placeName.isEmpty ? Color.gray : Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 15)
            }
            .navigationTitle("Edit Saved Place")
            .navigationBarTitleDisplayMode(.inline)
        }

    }
}

#Preview {
    EditSavedPlace(address: Address(id: "sampleID", name: "Home", address: "123 Main St"))
}
