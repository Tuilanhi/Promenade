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
                        .renderingMode(.template)
                    Text("Home")
                }
            ActivityPageView()
                .tabItem {
                    Image("ActivityIcon")
                        .renderingMode(.template)
                    Text("Activity")
                }
            AccountPageView()
                .tabItem {
                    Image("AccountIcon")
                        .renderingMode(.template)
                    Text("Account")
                }
        }
        .accentColor(.black)
    }
}

#Preview {
    BottomNavigation()
}
