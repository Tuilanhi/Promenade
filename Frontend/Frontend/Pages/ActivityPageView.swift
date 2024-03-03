//
//  ActivityPageView.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import SwiftUI

struct ActivityPageView: View {
    // Mock activity data
    var activities = [
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        Activity(finalDestination: "366 East Golden Star Dr.", date: "Feb 14 · 9:30 PM", price: 25.16),
        
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Past")
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.leading)
                        .padding(.top)
                    
                    ForEach(activities) { activity in
                        ActivityCard(activity: activity)
                    }
                }
            }
            .navigationTitle("Activity")
        }
    }
}

#Preview {
    ActivityPageView()
}
