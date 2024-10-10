//
//  AddEditEventView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct AddEditEventView: View {
    @EnvironmentObject var facultyVM: FacultyViewModel
    @Environment(\.dismiss) private var dismiss
    @State var selectedColor: Color = .blue31
    @State var title: String = ""
    @State var description: String = ""
    @State var startDate: String = ""
    @State var startTime: String = ""
    @State var endDate: String = ""
    @State var endTime: String = ""
    @State var timeZone: String = ""
    var body: some View {
        ZStack{
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(alignment: .center, spacing: 20){
                    Image(systemName: "xmark")
                        .customLabelStyle(textColor: .gray64, fontSize: 22, fontName: .generalSansSemiBold)
                        .onTapGesture {
                            dismiss.callAsFunction()
                        }
                    
                    Text("Add or Edit Event")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansSemiBold)
                }
                
                AnimatedTextField(text: $title, placeholder: "Title")
                
                AnimatedTextField(text: $description, placeholder: "Description")
                
                HStack(spacing: 30){
                    AnimatedTextField(text: $startDate, placeholder: "Start Date")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray111)
                        })
                    
                    AnimatedTextField(text: $startTime, placeholder: "Start Time")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "clock")
                                .foregroundColor(.gray111)
                        })
                }
                
                HStack(spacing: 30){
                    AnimatedTextField(text: $endDate, placeholder: "End Date")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray111)
                        })
                    
                    AnimatedTextField(text: $endTime, placeholder: "End Time")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "clock")
                                .foregroundColor(.gray111)
                        })
                }
                    
                AnimatedTextField(text: $timeZone, placeholder: "Time Zone")
                    
                VStack(alignment: .leading, spacing: 10){
                    Text("Choose Color")
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansRegular)
                    HStack{
                        let colors: [Color] = [.blue31, .green79, .orange, .anyBlack]
                        ForEach(colors, id: \.self) { color  in
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                                .overlay(alignment: .center, content: {
                                    if selectedColor == color {
                                        Image(systemName: "checkmark").customLabelStyle(textColor: .anyWhite, fontSize: 10, fontName: .generalSansBold)
                                    }
                                })
                                .onTapGesture {
                                    selectedColor = color
                                }
                        }
                    }
                }
                Spacer(minLength: 0)
                Button(action: {
                    dismiss.callAsFunction()
                }, label: {
                    Text("Confirm")
                        .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                })
            }.frame(width: .screen48Width).background(.anyWhite)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
    }
}

#Preview {
    AddEditEventView()
}
