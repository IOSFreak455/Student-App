//
//  ForgotPasswordView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var facultyVM: FacultyLoginViewModel
    @State private var email: String = ""
    var body: some View {
        ZStack{
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(alignment: .center, spacing: 20){
                    Image(systemName: "xmark")
                        .customLabelStyle(textColor: .gray64, fontSize: 22, fontName: .generalSansSemiBold)
                        .onTapGesture {
                            self.facultyVM.isForgotPassword = false
                        }
                    
                    Text("Forgot Password")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansSemiBold)
                }
                
                Text("Please enter your registered email address below. We wil send you a link to reset your password")
                    .customLabelStyle(textColor: .gray64, fontSize: 20, fontName: .generalSansRegular)
                    .padding(.trailing)
                    
                
                TextField("Email ID", text: $email)
                    .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansRegular)
                    .padding(.vertical)
                    .overlay(Rectangle().frame(height: 1).foregroundColor(email.isEmpty ? .gray153 : .anyBlack), alignment: .bottom)
                    .tint(.gray153)
                
                Spacer(minLength: 0)
                
                Button(action: {
                    self.facultyVM.isForgotPassword = false
                    self.facultyVM.postRequest(endPoint: .forgotPasword, params: ["email" : email])
                }, label: {
                    Text("Send Link")
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
    ForgotPasswordView()
}
