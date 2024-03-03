//
//  AddSavedAddress.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct AddSavedAddress: View {
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
    
    @State var searchQuery = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Enter an address", text: $searchQuery)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if !searchQuery.isEmpty {
                        Button(action: {
                            searchQuery = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                .frame(height: 40)
                .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemGray6)))
                .padding()
                
                List{
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
                }.listStyle(PlainListStyle())
                
                Spacer()
            }
            .navigationTitle("Add Place")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddSavedAddress()
}
