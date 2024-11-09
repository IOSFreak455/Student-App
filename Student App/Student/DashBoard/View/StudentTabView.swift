//
//  StudentTabView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct StudentTabView: View {
    @StateObject var vm: StudentViewModel = StudentViewModel()
    @State var selectedIndex: Int = 0
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView(selectedTab: $selectedIndex)
                .tabItem {
                    Label("Home", systemImage: "house")
                } .tag(0)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                } .tag(1)
            
            AppointmentsView()
                .tabItem {
                    Label("Appointments", systemImage: "calendar")
                }  .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }  .tag(3)
        }.environmentObject(vm).tint(.blue31)
            .onAppear(perform: {
                UITabBar.appearance().unselectedItemTintColor = .gray111
                UITabBarItem.appearance().badgeColor = .red
                UITabBar.appearance().backgroundColor = .white252
                //UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
                //Above API will kind of override other behaviour and bring the default UI for TabView
            })
    }
}

#Preview {
    StudentTabView()
}
