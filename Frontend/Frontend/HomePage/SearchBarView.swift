//
//  SearchBarView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct SearchBarView: View {
    @State private var searchQuery = ""
    
    var body: some View {
        VStack {
            // Search bars
            HStack {
                // Search Icon
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                
                // Search Text Field
                TextField("Where To?", text: $searchQuery)
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
