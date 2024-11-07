//
//  AppointmentDetailsView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct AppointmentDetailsView: View {
    @EnvironmentObject var vm : StudentViewModel
    var body: some View {
        LoadingView(isLoading: $vm.isLoading){
            ZStack{
                Color.white252.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 20){
                    HStack(spacing: 20){
                        BackButtonView(fontSize: 22)
                        Text("Pick a slot")
                            .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                    }
                    
                    VStack(alignment: .leading, spacing: 20){
                        Text(vm.bookSlot.universityName)
                            .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansSemiBold)
                        
                        Text(vm.bookSlot.rankName)
                            .customLabelStyle(textColor: .blue31, fontSize: 12, fontName: .generalSansSemiBold)
                            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .background(Color.white248)
                            .clipShape(Capsule())
                            .offset(y: -10)
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text("Representative Names")
                                .customLabelStyle(textColor: .black50, fontSize: 17, fontName: .generalSansSemiBold)
                            
                            RepresentavtivesTitleCell(fontSize: 16, size: 50, isHideName: false, isHideCheckMark: .constant(false), model: vm.bookSlot.repData)
                        }
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text("Appointment Details")
                                .customLabelStyle(textColor: .black50, fontSize: 17, fontName: .generalSansSemiBold)
                            
                            Label("On \(vm.bookSlot.appointmentDate)", systemImage: "calendar").tracking(1)
                                .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansMedium)
                            Label(vm.bookSlot.appointmentSlot, systemImage: "clock").tracking(1)
                                .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansMedium)
                            
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        let params = ["appointmentDate": vm.selectedDate.datetoymdformate(format: "yyyy-MM-dd"),
                                      "appointmentSlot": vm.bookSlot.appointmentSlot,
                                      "location": vm.bookSlot.location,
                                      "phoneNumber": vm.studentDetails?.phonenumber ?? "",
                                      "repName": "Anudeep Varma",
                                      "studentName": vm.studentDetails?.studentname ?? "",
                                      "universityName": vm.bookSlot.universityName]
                        self.vm.postRequest(endPoint: .bookAppointment, params: params)
                    }, label: {
                        Text("Confirm")
                            .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                    })
                    .navigationDestination(isPresented: $vm.isBookAppointment, destination: {
                        StudentTabView().navigationBarBackButtonHidden()
                    })
                  
                }.padding(.horizontal)
            }
        }
    }
}

#Preview {
    AppointmentDetailsView().environmentObject(StudentViewModel())
}
