//
//  FacultyTabView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct FacultyTabView: View {
    @ObservedObject var vm: FacultyViewModel = FacultyViewModel()
    @State var selectedIndex: Int = 0
    var body: some View {
        TabView(selection: $selectedIndex) {
            FacultyHomeView().environmentObject(vm)
                .tabItem {
                    Label("Home", systemImage: "house")
                } .tag(0)
            
            FacultyCalendarView().environmentObject(vm)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                } .tag(1)
            
            FacultyHistoryView().environmentObject(vm)
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }  .tag(2)
            
            UniveristyProfileView().environmentObject(vm)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }  .tag(3)
        }.tint(.blue31)
            .onAppear(perform: {
                UITabBar.appearance().unselectedItemTintColor = .gray111
                UITabBarItem.appearance().badgeColor = .red
                UITabBar.appearance().backgroundColor = .white252
                //UITabBar.appearance().scrollEdgeAppearance = UITabBarAppearance()
                //Above API will kind of override other behaviour and bring the default UI for TabView
            })
            .onAppear{
                self.vm.postRequest(endPoint: .getAllAppointments)
            }
    }
}

#Preview {
    FacultyTabView()
}
