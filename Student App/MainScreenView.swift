//
//  MainScreenView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct MainScreenView: View {
    var body: some View {
        Image("Launch-Screen").resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Select Role:")
                        .customLabelStyle(textColor: .anyWhite, fontSize: 25, fontName: .generalSansBold)
                        .italic()
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(), label: {
                        Text("Student")
                            .customLabelStyle(textColor: .anyWhite, fontSize: 23, fontName: .generalSansBold)
                            .frame(width: .screen24Width, height: 65)
                            .background(Color.blue31)
                            .cornerRadius(10)
                    })
                    
                    NavigationLink(destination: LoginFacultyView().navigationBarBackButtonHidden(), label: {
                        Text("Faculty")
                            .customLabelStyle(textColor: .anyWhite, fontSize: 23, fontName: .generalSansBold)
                            .frame(width: .screen24Width, height: 65)
                            .background(Color.green79)
                            .cornerRadius(10)
                    })
                }.padding(.bottom)
            }
    }
}

#Preview {
    MainScreenView()
}
