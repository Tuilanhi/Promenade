//
//  DestinationSelectionView.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI

struct DestinationSelectionPageView: View {
    
    @State private var start: String = ""
    @State private var destination: String = ""
    
    
    var body: some View {
        
        VStack {
            TextField(
                "Enter Start",
                text: $start
            )
            .border(Color.black)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing], 25)
            
            TextField(
                "Enter Destination",
                text: $destination
            )
            .border(Color.black)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing], 25)
        }
        .padding([.top, .bottom], 50)
        Spacer()
    }
}

#Preview {
    DestinationSelectionPageView()
}
