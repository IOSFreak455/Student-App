//
//  LoginFacultyView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct LoginFacultyView: View {
    @StateObject var facultyVM: FacultyLoginViewModel = FacultyLoginViewModel()
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    var body: some View {
        LoadingView(isLoading: $facultyVM.isLoading) {
            ZStack {
                VStack{
                    ZStack{
                        Image("one").resizable()
                        Text("Effortlessly access\nstudent details")
                            .customLabelStyle(textColor: .anyWhite, fontSize: 40, fontName: .generalSansSemiBold)
                            .frame(width: .screenWidth, height: .screenHeight/2.4)
                            .background(Color.anyBlack.opacity(0.7))
                    }
                    .frame(width: .screenWidth, height: .screenHeight/2.4)
                    VStack(alignment: .leading, spacing: 20){
                        Text("Login")
                            .customLabelStyle(textColor: .black50, fontSize: 25, fontName: .generalSansSemiBold)
                            .padding(.top)
                        
                        TextField("Username", text: $username)
                            .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansRegular)
                            .padding(.vertical)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(username.isEmpty ? .gray153 : .anyBlack), alignment: .bottom)
                        
                        HStack {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                            
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(password.isEmpty ? .gray153 : .anyBlack )
                            }
                            .padding(.trailing)
                        }.padding(.vertical)
                            .overlay(Rectangle().frame(height: 1).foregroundColor(password.isEmpty ? .gray153 : .anyBlack), alignment: .bottom)
                            .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansRegular)
                    
                            Text("Forgot password?")
                                .customLabelStyle(textColor: .blue31, fontSize: 16, fontName: .generalSansMedium)
                                .onTapGesture {
                                    self.facultyVM.isForgotPassword = true
                                }
                        
                        Spacer(minLength: 0)
                        
                        Text("Login")
                            .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                            .onTapGesture {
                                if username.isEmpty {
                                    self.facultyVM.showToastMessage("Please enter emailId..!", type: .error)
                                    return
                                } else if password.isEmpty {
                                    self.facultyVM.showToastMessage("Please enter password..!", type: .error)
                                    return
                                }
                                self.facultyVM.validateFacultyLogin(userName: username, password: password)
//                                self.facultyVM.isLoading = true
//                                self.facultyVM.postRequest(endPoint: .authenticate, params: ["username" : username, "password": password])
                            }
                            .navigationDestination(isPresented: $facultyVM.isTabPageView, destination: {
                                FacultyTabView().navigationBarBackButtonHidden()
                            })
                    }.frame(width: .screen48Width).tint(.gray153)
                }.background(Color.white252).edgesIgnoringSafeArea(.top)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                if facultyVM.isForgotPassword {
                    ForgotPasswordView().environmentObject(facultyVM).navigationBarBackButtonHidden()
                }
            }
            .overlay(facultyVM.showToast ? ToastView(style: facultyVM.toastType, message: facultyVM.toastMessage ?? "", isShowing: $facultyVM.showToast) : nil, alignment: .top)
        }
        .onAppear {
            APIUrls.isStudent = false
        }
    }
}

#Preview {
    LoginFacultyView()
}
