//
//  AddSavedAddress.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI


struct AddSavedAddress: View {
    @StateObject var viewModel = LocationSearchViewModel() // Initialize the view model for address search
    @FocusState private var isFocusedTextField: Bool // State to manage focus on the text field

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Enter an address", text: $viewModel.destinationQuery)
                    .autocorrectionDisabled()
                    .focused($isFocusedTextField)
                    .font(.title2)
                    .overlay {
                        ClearButton(text: $viewModel.destinationQuery)
                            .padding(.trailing)
                    }
                    .onAppear {
                        isFocusedTextField = true
                    }
                    .padding(.horizontal)
                    .frame(height: 40)
                    .background(RoundedRectangle(cornerRadius: 0).fill(Color(.systemGray6)))
                    .padding()

                List(viewModel.destinationResults, id: \.self) { result in // Iterate over viewModel.results
                    NavigationLink(destination: SavePlaceView(address: result.title)) {
                        VStack(alignment: .leading) {
                            Text(result.title)
                            Text(result.subtitle).font(.subheadline).foregroundColor(.gray)
                        }
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
