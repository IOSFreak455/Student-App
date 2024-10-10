//
//  GiveFeedbackView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct GiveFeedbackView: View {
    @State var model: AllAppointmentModel
    @EnvironmentObject var facultyVM: FacultyViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isEligibility: Bool = true
    @State private var isScholarship: Bool = true
    @State private var comments: String = ""
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
                    
                    Text("Give Feedback")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansSemiBold)
                }
                HStack(alignment: .top){
                    Image("two").resizable()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    Text("\(model.studentname ?? "balaji")")
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansSemiBold)
                        .offset(y: 20)
                }
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Eligibility")
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansMedium)
                    HStack(spacing: 30){
                        Label { Text("Yes") } icon: {
                            Image(systemName: isEligibility ? "record.circle" : "circle")
                                .foregroundColor(isEligibility ? .blue31 : .black50)
                                .onTapGesture { self.isEligibility = true }
                        }
                        
                        Label { Text("No") } icon: {
                            Image(systemName: !isEligibility ? "record.circle" : "circle")
                                .foregroundColor(!isEligibility ? .blue31 : .black50)
                                .onTapGesture { self.isEligibility = false }
                        }
                    }.customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansMedium).accentColor(.blue31)
                }.padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Scholarship")
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansMedium)
                    HStack(spacing: 30){
                        Label { Text("Yes") } icon: {
                            Image(systemName: isScholarship ? "record.circle" : "circle")
                                .foregroundColor(isScholarship ? .blue31 : .black50)
                                .onTapGesture { self.isScholarship = true }
                        }
                        
                        Label { Text("No") } icon: {
                            Image(systemName: !isScholarship ? "record.circle" : "circle")
                                .foregroundColor(!isScholarship ? .blue31 : .black50)
                                .onTapGesture { self.isScholarship = false }
                        }
                    }.customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansMedium).accentColor(.blue31)
                }.padding(.bottom, 10)
                
                VStack(alignment: .leading, spacing: 10){
                    Text("Additional Notes")
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansMedium)
                    TextEditor(text: $comments)
                        .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansMedium)
                        .padding()
                        .scrollContentBackground(.hidden)
                        .frame(maxWidth: .screen48Width, minHeight: 50)
                        .background(Color.white248)
                        .cornerRadius(20)
                        .tint(.black50)
                }
                    
                Spacer(minLength: 20)
                Button(action: {
                    self.facultyVM.postRequest(endPoint: .giveFeedback, params: ["feedback": comments, "id": "\(model.id)"])
                    dismiss.callAsFunction()
                }, label: {
                    Text("Submit")
                        .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                })
            }.frame(width: .screen48Width).background(Color.anyWhite)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
    }
}

#Preview {
    GiveFeedbackView(model: AllAppointmentModel(id: 0, universityname: "Name", studentname: "Student", location: "Location", repname: "Rep Name", appointmentdate: "Appointment", appointmentslot: "Appointment", createdatetime: "Created", pass_out_year: "2024", category: "New", mailId: "studnt@gmail.com"))
}

struct ToggleCircleButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(label, systemImage: isSelected ? "circle.fill" : "circle")
                .labelStyle(IconOnlyLabelStyle())
                .foregroundColor(isSelected ? .blue : .gray)
                .font(.title)
                .padding()
        }
    }
}
