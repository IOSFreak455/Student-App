//
//  FacultyCalendarView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct FacultyCalendarView: View {
    @EnvironmentObject var facultyVM: FacultyViewModel
    @State private var selectedDate = Date()
    @State private var isEditAddEvent: Bool = false
    var body: some View {
        ZStack{
            Color.white251
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                Text("History")
                    .customLabelStyle(textColor: .black50, fontSize: 24, fontName: .generalSansSemiBold)
                
                DatePicker("Select a date", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                
                Spacer(minLength: 0)
                
                
                CreatedEventCell(label: "On Vacation", date: "17 Aug - 23 Aug")
                    .onTapGesture {
                        self.isEditAddEvent = true
                    }
                
                Button(action: {
                    self.isEditAddEvent = true
                }, label: {
                    Label("Create Event", systemImage: "plus")
                        .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                }).navigationDestination(isPresented: $isEditAddEvent, destination: {
                    AddEditEventView().environmentObject(facultyVM).navigationBarBackButtonHidden()
                })
            }.frame(width: .screen48Width, alignment: .leading).background(Color.anyWhite)
        }
    }
}

#Preview {
    FacultyCalendarView().environmentObject(FacultyViewModel())
}

struct CreatedEventCell: View {
    @State var label: String
    @State var date: String
    var body: some View {
        HStack(spacing: 15){
            Image(systemName: "calendar")
                .resizable()
                .frame(width: 35, height: 30)
                .foregroundColor(.blue31)
            VStack(alignment: .leading){
                Text(label)
                    .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansMedium)
                Text(date).tracking(1)
                    .customLabelStyle(textColor: .gray111, fontSize: 16, fontName: .generalSansRegular)
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
            .padding()
            .background(Color.anyWhite)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black50, lineWidth: 0.5))
    }
}
