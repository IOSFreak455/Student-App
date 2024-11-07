//
//  FacultyHomeView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct FacultyHomeView: View {
    @EnvironmentObject var vm: FacultyViewModel
    var body: some View {
        LoadingView(isLoading: $vm.isLoading){
            ZStack{
                Color.white251
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0){
                    Text("Upcoming Appointments")
                        .customLabelStyle(textColor: .black50, fontSize: 24, fontName: .generalSansSemiBold)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(vm.allAppointments, id: \.self){ data in
                            StudentAppointmentCell(model: data, isMessageIcon: true).environmentObject(vm)
                        }.padding(.top, 10)
                    }
                    Spacer(minLength: 0)
                }.frame(width: .screen24Width, alignment: .leading)
            }
            .overlay(vm.showToast ? ToastView(style: vm.toastType, message: vm.toastMessage ?? "", isShowing: $vm.showToast) : nil, alignment: .top)
        }
    }
}

#Preview {
    FacultyHomeView().environmentObject(FacultyViewModel())
}

struct StudentAppointmentCell: View {
    @State var model: AllAppointmentModel
    @EnvironmentObject var vm: FacultyViewModel
    @State var isMessageIcon: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("\(model.appointmentdate?.formattedDate() ?? "Aug 24th 2024") | \(model.appointmentslot ?? "01:00-02:00")").tracking(1)
                .customLabelStyle(textColor: .anyWhite, fontSize: 12, fontName: .generalSansMedium)
                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                .background(Color.green79)
                .clipShape(Capsule())
               
            HStack(alignment: .top, spacing: 20){
                Image("two").resizable()
                     .frame(width: 80, height: 80)
                     .clipShape(RoundedRectangle(cornerRadius: 30))
                VStack(alignment: .leading, spacing: 4){
                    HStack{
                        Text(model.studentname ?? "Balaji")
                        if isMessageIcon {
                            NavigationLink(destination: GiveFeedbackView(model: model).environmentObject(vm).navigationBarBackButtonHidden(), label: {
                                Image(systemName: "ellipsis.message.fill")
                                    .foregroundColor(.blue31)
                            })
                        }
                    }.customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansSemiBold)
                    Text(model.mailId ?? "\(model.studentname ?? "balaji")@gmail.com")
                        .customLabelStyle(textColor: .gray111, fontSize: 16, fontName: .generalSansMedium)
                    HStack(alignment: .top, spacing: 5){
                        VStack(alignment: .leading, spacing: 4){
                            Text("Passed Out Year")
                                .customLabelStyle(textColor: .black50, fontSize: 14, fontName: .generalSansRegular)
                            Text(model.pass_out_year ?? "2022")
                                .customLabelStyle(textColor: .black50, fontSize: 14, fontName: .generalSansMedium)
                        }
                        Spacer(minLength: 0)
                        Rectangle()
                            .frame(width: 1, height: 35)
                        Spacer(minLength: 0)
                        VStack(alignment: .leading, spacing: 4){
                            Text("Category")
                                .customLabelStyle(textColor: .black50, fontSize: 14, fontName: .generalSansRegular)
                            Text(model.pass_out_year ?? "Bachelors")
                                .customLabelStyle(textColor: .black50, fontSize: 14, fontName: .generalSansMedium)
                        }
                        Spacer(minLength: 0)
                    }.padding(.top)
                }
            }
        }.padding().background(.anyWhite)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.vertical, 8)
    }
}
