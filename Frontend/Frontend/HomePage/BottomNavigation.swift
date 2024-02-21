//
//  BottomNavigation.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//

import SwiftUI

struct BottomNavigation: View {
    init() {
        // Use this to set the color of the unselected state
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Image("HomeIcon")
                    Text("Home")
                }
            HomePageView()
                .tabItem {
                    Image("ActivityIcon")
                    Text("Activity")
                }
            HomePageView()
                .tabItem {
                    Image("AccountIcon")
                    Text("Account")
                }
        }
        .tint(.black)
    }
}

#Preview {
    BottomNavigation()
}
