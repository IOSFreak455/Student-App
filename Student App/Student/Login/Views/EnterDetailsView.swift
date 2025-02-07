//
//  EnterDetailsView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct EnterDetailsView: View {
    @EnvironmentObject var vm: StudentLoginViewModel
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var isShowSheet = false
    @State private var sourceType: SourceType = .camera
    @State private var isUploadSheet: Bool = false
    @State var selectedImage: UIImage?
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            BackButtonView()
            Text("Enter your details")
                .customLabelStyle(textColor: .black50, fontSize: 20, fontName: .generalSansBold)
                .padding(.top, 12)
            Text("Enter your details to proceesd")
                .customLabelStyle(textColor: .gray64, fontSize: 16, fontName: .generalSansRegular)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10){
                    VStack {
                        if let imageToPreview = selectedImage {
                            Image(uiImage: imageToPreview)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                                .frame(width: 120, height: 120)
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                        } else {
                            Image("user_placeholder").resizable()
                                .frame(width: 120, height: 120)
                        }
                    } .overlay(alignment: .bottomTrailing, content: {
                            Image(systemName: "pencil.circle.fill").resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.orange)
                                .offset(y: -15)
                        })
                        .onTapGesture {
                            self.isShowSheet = true
                        }
                        .confirmationDialog("Choose an option", isPresented: $isShowSheet) {
                            Button("Camera"){
                                if vm.isCameraAccessDenied {
                                    vm.checkInitialAccessStatus()
                                    self.isShowSheet = false
                                } else {
                                    sourceType = .camera
                                    self.isUploadSheet = true
                                }
                            }
                            Button("Photo Library"){
                                if vm.isPhotoLibraryAccessDenied {
                                    vm.checkInitialAccessStatus()
                                    self.isShowSheet = false
                                } else {
                                    sourceType = .photoLibrary
                                    self.isUploadSheet = true
                                }
                            }
                        }
                        .frame(width: .screen24Width, alignment: .center)
                        .padding(.top)
                    
                    AnimatedTextField(text: $firstName, placeholder: "First Name")
                    
                    AnimatedTextField(text: $lastName, placeholder: "Last Name")
                    
                    AnimatedTextField(text: $email, placeholder: "Email Address")
                    
//                    AnimatedTextField(text: $email, placeholder: "University Name")
//                    
//                    AnimatedTextField(text: $email, placeholder: "Location")
                }
            }
            Spacer(minLength: 0)
            
            Text("Continue")
                .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen48Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                .onTapGesture {
                    guard self.validateFeilds() else {
                        return
                    }
                    let params: [String: String] = ["email": email,
                                                    "phonenumber": vm.phoneNumber,
                                                    "studentname": firstName + " " + lastName
                                                   ]
                    self.vm.postRequest(endPoint: .createStudent, params: params)
                }
                .navigationDestination(isPresented: $vm.isCreateAccount, destination: {
                    StudentTabView().navigationBarBackButtonHidden()
                })
        }.padding(.horizontal, 24)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .overlay(vm.showToast ? ToastView(style: vm.toastType, message: vm.toastMessage ?? "", isShowing: $vm.showToast) : nil, alignment: .top)
            .sheet(isPresented: $isUploadSheet) {
                ImagePicker(sourceType: sourceType == .camera ? .camera : .photoLibrary, onImagePicked: { image, url in
                    self.vm.saveImageToUserDefaults(image: image, key: "profileImage")
                    self.selectedImage = image
                }, onCancel: {
                    self.isUploadSheet = false
                }).edgesIgnoringSafeArea(.bottom)
            }
    }
    func validateFeilds() -> Bool {
        if firstName.isEmpty {
            self.vm.showToastMessage("Please enter first name", type: .error)
            return false
        } else if lastName.isEmpty {
            self.vm.showToastMessage("Please enter last name", type: .error)
            return false
        } else if email.isEmpty || !textFieldValidatorEmail(email) {
            self.vm.showToastMessage("Please enter valid email", type: .error)
            return false
        }
        return true
    }
}

#Preview {
    EnterDetailsView()
}

extension View {
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        //let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}
