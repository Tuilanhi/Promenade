//
//  AddSavedAddress.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI


struct AddSavedAddress: View {
    @StateObject var viewModel = AddressViewModel() // Initialize the view model for address search
    @FocusState private var isFocusedTextField: Bool // State to manage focus on the text field

    var body: some View {
        NavigationStack {
            VStack {
                // Replace the old search bar with the new one
                TextField("Enter an address", text: $viewModel.searchableText)
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.title2)
                    .onReceive(
                        viewModel.$searchableText.debounce(
                            for: .seconds(1),
                            scheduler: DispatchQueue.main
                        )
                    ) {
                        viewModel.searchAddress($0)
                    }
                    .overlay {
                        ClearButton(text: $viewModel.searchableText)
                            .padding(.trailing)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 0).fill(Color(.systemGray6)))
                    .padding()
                List(self.viewModel.results) { address in
                    NavigationLink(destination: SavePlaceView(address: address.title)) {
                        AddressRow(address: address)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddSavedAddress_Previews: PreviewProvider {
    static var previews: some View {
        AddSavedAddress()
    }
}
