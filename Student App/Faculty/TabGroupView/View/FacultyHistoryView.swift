//
//  FacultyHistoryView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct FacultyHistoryView: View {
    @EnvironmentObject var vm: FacultyViewModel
    var body: some View {
        LoadingView(isLoading: $vm.isLoading){
            ZStack{
                Color.white251
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0){
                    Text("History")
                        .customLabelStyle(textColor: .black50, fontSize: 24, fontName: .generalSansSemiBold)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(vm.allAppointments, id: \.self){ data in
                            StudentAppointmentCell(model: data, isMessageIcon: false).environmentObject(vm)
                        }.padding(.top, 10)
                    }
                    Spacer(minLength: 0)
                }.frame(width: .screen24Width, alignment: .leading)
            }
        }
    }
}

#Preview {
    FacultyHistoryView().environmentObject(FacultyViewModel())
}
