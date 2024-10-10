//
//  ProfileView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: StudentViewModel
    var body: some View {
        ZStack{
            Color.white252
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                Text("Hey, \(vm.studentDetails?.studentname ?? "")")
                    .customLabelStyle(textColor: .black50, fontSize: 24, fontName: .generalSansSemiBold)
                    .padding(.bottom, 30)
                
                NavigationLink(destination: ProfileDetailView().environmentObject(vm) .navigationBarBackButtonHidden(), label: {
                    ProfileActionCell(label: "Profile")
                })
                
                NavigationLink(destination: MainScreenView().navigationBarBackButtonHidden(), label: {
                    ProfileActionCell(label: "Logout")
                })
                
                Spacer()
            }.frame(width: .screen24Width, alignment: .leading)
        }
    }
}

struct UniveristyProfileView: View {
    @EnvironmentObject var facultyVm: FacultyViewModel
    var body: some View {
        ZStack{
            Color.white252
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                Text("Hey, Shyam")
                    .customLabelStyle(textColor: .black50, fontSize: 24, fontName: .generalSansSemiBold)
                    .padding(.bottom, 30)
                
                NavigationLink(destination: UniversityProfileDetailView().environmentObject(facultyVm).navigationBarBackButtonHidden(), label: {
                    ProfileActionCell(label: "Profile")
                })
                
                NavigationLink(destination: MainScreenView().navigationBarBackButtonHidden(), label: {
                    ProfileActionCell(label: "Logout")
                })
                
                Spacer()
            }.frame(width: .screen24Width, alignment: .leading)
        }
    }
}


#Preview {
    ProfileView()
}

struct ProfileActionCell: View {
    @State var label: String
    var body: some View {
        HStack{
            Text(label)
            Spacer()
            Image(systemName: "chevron.right")
        }.customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansMedium)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.black50, lineWidth: 0.5))
            .padding(.horizontal)
    }
}
