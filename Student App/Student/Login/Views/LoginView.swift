//
//  LoginView.swift
//  Student App
//
//  Created by Arjun   on 12/07/24.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var vm: StudentLoginViewModel = StudentLoginViewModel()
    @State private var code: String = ""
    @State private var isOTPView: Bool = false
    var body: some View {
        LoadingView(isLoading: $vm.isLoading) {
            VStack(alignment: .leading, spacing: 10){
                Text("Enter Your Phone Number")
                    .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansBold)
                    .padding(.top, 12)
                Text("Login with your phone numnber")
                    .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
                
                HStack{
                    VStack(alignment: .center){
                        TextField("+91", text: $code)
                            .customLabelStyle(textColor: .anyBlack, fontSize: 16, fontName: .generalSansMedium)
                        Divider()
                    }.frame(width: 60, alignment: .center)
                    
                    VStack{
                        TextField("Phone Number", text: $vm.phoneNumber).tracking(1.0)
                            .onChange(of: self.vm.phoneNumber) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered.count > 10 {
                                    vm.phoneNumber = String(filtered.prefix(10))
                                } else {
                                    vm.phoneNumber = filtered
                                }
                            }
                            .customLabelStyle(textColor: .anyBlack, fontSize: 16, fontName: .generalSansMedium)
                        Divider()
                    }
                }.keyboardType(.numberPad).tint(.anyBlack)
                    .padding(.top, 40)
                Spacer(minLength: 0)
                Text("Continue")
                    .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                    .onTapGesture {
                        self.vm.postQueryRequest(endPoint: .isUserExists, params: ["phoneNumber": vm.phoneNumber])
                        self.isOTPView = true
                    }
                    .navigationDestination(isPresented: $isOTPView, destination: {
                        OTPView().environmentObject(vm).navigationBarBackButtonHidden()
                    })
                    .disabled(vm.phoneNumber.count != 10)
                    .opacity(vm.phoneNumber.count == 10 ? 1.0 : 0.5)
                    .padding(.bottom)
                
            }.padding(.horizontal, 24).background(Color.anyWhite)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            .overlay(vm.showToast ? ToastView(style: vm.toastType, message: vm.toastMessage ?? "", isShowing: $vm.showToast) : nil, alignment: .top)
        }
        .onAppear {
            APIUrls.isStudent = true
        }
    }
}

#Preview {
    LoginView()
}
