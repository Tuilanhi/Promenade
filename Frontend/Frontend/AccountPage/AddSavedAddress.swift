//
//  AddSavedAddress.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI


struct AddSavedAddress: View {
    let savedAddresses = [
        // Your saved addresses
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
        ("Home", "1234 Street Dr"),
    ]
    
    @StateObject var viewModel = AddressViewModel() // Initialize the view model for address search
    @FocusState private var isFocusedTextField: Bool // State to manage focus on the text field

    var body: some View {
        NavigationView {
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

                // Assuming you want to keep the list of saved addresses
                // and possibly integrate search results from viewModel
                List(self.viewModel.results) { address in
                    AddressRow(address: address)
                }
                .scrollContentBackground(.hidden)
                .listStyle(PlainListStyle())

                Spacer()
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct AddSavedAddress_Previews: PreviewProvider {
    static var previews: some View {
        AddSavedAddress()
    }
}
