//
//  SavedAddressView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct SavedAddressView: View {
    // Example data - replace with your actual data source
        let savedAddresses = [
            ("Home", "1234 Street Dr"),
            ("Work", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Work", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            ("Home", "1234 Street Dr"),
            
            // Add more addresses as needed
        ]
    
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
                ForEach(savedAddresses, id: \.self.0) { label, address in
                    HStack{
                        Image(systemName: "star.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                        VStack(alignment: .leading) {
                            Text(label)
                                .foregroundColor(.black)
                            Text(address)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Choose a Place")
            .navigationBarItems(trailing: EditButton())
        }
        
    }
}

#Preview {
    SavedAddressView()
}
