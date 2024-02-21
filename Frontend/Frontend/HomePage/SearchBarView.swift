//
//  SearchBarView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct SearchBarView: View {
    @State private var searchQuery1 = ""
    @State private var searchQuery2 = ""
    
    var body: some View {
        VStack {
            // Search bars
            HStack {
                // Search Icon
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                
                // Search Text Field
                TextField("Start Destination", text: $searchQuery1)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 40)
            .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemGray6)))

            // Search bars
            HStack {
                // Search Icon
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                
                // Search Text Field
                TextField("Destination", text: $searchQuery2)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(height: 40)
            .background(RoundedRectangle(cornerRadius: 18).fill(Color(.systemGray6)))
        }
        .frame(width: 350)
    }
}

#Preview {
    SearchBarView()
}
