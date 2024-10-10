//
//  OTPView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var vm: StudentLoginViewModel
    @State var activeIndicatorColor: Color = Color.blue31
    @State var inactiveIndicatorColor: Color = Color.gray
//    @State var doSomething: (String) -> Void
    @State var length: Int = 4
    @State var isVerifyOTP: Bool = false
    @State private var otpText = ""
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            BackButtonView()
            Text("Enter 4 Digits Code")
                .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansBold)
                .padding(.top, 12)
            Text("OTP needs to be enter with \(vm.phoneNumber.prefix(1))xx xxx x\(vm.phoneNumber.suffix(3))")
                .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
            
            HStack(spacing: 20){
                ForEach(0...length-1, id: \.self) { index in
                    OTPTextBox(index)
                        .customLabelStyle(textColor: .black50, fontSize: 18, fontName: .generalSansMedium)
                }
            }.background(content: {
                TextField("", text: $otpText.limit(4))
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .frame(width: 1, height: 1)
                    .opacity(0.001)
                    .blendMode(.screen)
                    .focused($isKeyboardShowing)
                    .onChange(of: otpText) { newValue in
                        if newValue.count == length {
                            //doSomething(newValue)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.async {
                            isKeyboardShowing = true
                        }
                    }
            })
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardShowing = true
            }.tint(.anyBlack)
                .padding(.top, 30)
            Text("Resend OTP")
                .customLabelStyle(textColor: .blue31, fontSize: 16, fontName: .generalSansMedium)
                .padding(.top, 10)
            Spacer()
                Text("Confirm OTP")
                    .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                    .onTapGesture {
                        if otpText == "1234" {
                            self.isVerifyOTP = true
                        }
                    }
                    .navigationDestination(isPresented: $isVerifyOTP, destination: {
                        if self.vm.isUserExist {
                            StudentTabView().navigationBarBackButtonHidden()
                        } else {
                            EnterDetailsView().environmentObject(vm).navigationBarBackButtonHidden()
                        }
                    })
                    .opacity(otpText.count == 4 ? 1.0 : 0.5)
//            .padding(.bottom)
        }.padding(.horizontal, 24).background(Color.anyWhite)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .overlay(vm.showToast ? ToastView(style: vm.toastType, message: vm.toastMessage ?? "", isShowing: $vm.showToast) : nil, alignment: .top)
    }
    @ViewBuilder
    func OTPTextBox(_ index: Int) -> some View {
        VStack(alignment: .center){
            ZStack{
                if otpText.count > index {
                    let startIndex = otpText.startIndex
                    let charIndex = otpText.index(startIndex, offsetBy: index)
                    let charToString = String(otpText[charIndex])
                    Text(charToString)
                } else {
                    Text("0")
                        .foregroundColor(.gray)
                }
            }.frame(width: 52, height: 32)
            let status = (isKeyboardShowing && otpText.count == index)
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .stroke(status ? activeIndicatorColor : inactiveIndicatorColor)
                .animation(.easeInOut(duration: 0.2), value: status)
                .frame(width: 52, height: 1)
        }
    }
}

#Preview {
    OTPView().environmentObject(StudentLoginViewModel())
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

