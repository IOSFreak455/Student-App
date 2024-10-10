//
//  AppointmentsView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct AppointmentsView: View {
    @EnvironmentObject var vm : StudentViewModel
    var body: some View {
        ZStack{
            Color.white252
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0){
                Text("Appointments")
                    .customLabelStyle(textColor: .black50, fontSize: 24, fontName: .generalSansSemiBold)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20){
                        ForEach(vm.upComingAppos, id: \.self) { data in
                            UniversityAppointmentCell(data: data)
                        }
                    }.padding(.vertical)
                }
                Spacer(minLength: 0)
            }.frame(width: .screen24Width)
        }
    }
}

#Preview {
    AppointmentsView()
}
