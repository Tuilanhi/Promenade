//
//  DestinationSelectionResultCell.swift
//  Frontend
//
//  Created by James Stautler on 2/25/24.
//

import SwiftUI

struct DestinationSelectionResultCell: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                Text(subtitle)
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

struct DestinationSelectionResultCell_Preview: PreviewProvider {
    static var previews: some View {
        DestinationSelectionResultCell(title: "Koala Tea", subtitle: "123 Main st.")
    }
}
