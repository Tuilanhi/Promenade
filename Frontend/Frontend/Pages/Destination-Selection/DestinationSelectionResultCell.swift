//
//  DestinationSelectionResultCell.swift
//  Frontend
//
//  Created by James Stautler on 2/25/24.
//

import SwiftUI

struct DestinationSelectionResultCell: View {
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Koala Tea")
                    .font(.body)
                Text("123 Something Street")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
        }
        .padding(.leading)
    }
}

#Preview {
    DestinationSelectionResultCell()
}
