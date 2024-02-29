//
//  AddressRow.swift
//  Frontend
//
//  Created by nhi vu on 2/28/24.
//

import SwiftUI

struct AddressRow: View {
    
    let address: AddressResult
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(address.title)
            Text(address.subtitle)
                .font(.caption)
        }.padding(.bottom, 2)

    }
}
