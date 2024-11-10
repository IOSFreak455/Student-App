//
//  ProfileDetailView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct ProfileDetailView: View {
    @EnvironmentObject var vm : StudentViewModel
    @State var name: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var location: String = ""
    @State var collegeName: String = ""
    @State var year: String = "2024"
    
    @State var selectedImage: UIImage?
    @State private var isShowSheet = false
    @State private var sourceType: SourceType = .camera
    @State private var isUploadSheet: Bool = false
    var body: some View {
        ZStack{
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing: 20){
                    BackButtonView(fontSize: 22)
                    Text("Profile")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                }
                
                VStack {
                    if let imageToPreview = selectedImage {
                        Image(uiImage: imageToPreview)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 160, height: 160)
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 10)
                    } else {
                        Image("user_placeholder").resizable()
                            .frame(width: 160, height: 160)
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
                VStack(alignment: .leading, spacing: 5) {
                    AnimatedTextField(text: $name, placeholder: "Name")
                    
                    AnimatedTextField(text: $collegeName, placeholder: "College Name")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "arrowtriangle.down.circle")
                        })
                    
                    AnimatedTextField(text: $phoneNumber, placeholder: "Mobile Number")
                        .disabled(true)
                    
                    AnimatedTextField(text: $email, placeholder: "Email Address")
                        .disabled(true)
                    
                    AnimatedTextField(text: $location, placeholder: "Location")
                    
                    AnimatedTextField(text: $year, placeholder: "Passed Out Year")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "arrowtriangle.down.circle")
                        })
                }.disabled(true)
                
                Spacer(minLength: 0)
                
               
                Text("Save")
                    .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                    .onTapGesture {
                        let params: [String: String] = ["email": email,
                                                        "phonenumber": phoneNumber,
                                                        "studentname": name,
                                                        "studentlocation": location,
                                                        "universityname": collegeName
                                                       ]
                        self.vm.postRequest(endPoint: .createStudent, params: params)
                    }
                    .navigationDestination(isPresented: $vm.isSavedAccount, destination: {
                        StudentTabView(selectedIndex: 3).navigationBarBackButtonHidden()
                    })
            }.padding(.horizontal).background(.anyWhite)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
        .sheet(isPresented: $isUploadSheet) {
            ImagePicker(sourceType: sourceType == .camera ? .camera : .photoLibrary, onImagePicked: { image, url in
                self.vm.saveImageToUserDefaults(image: image, key: "profileImage")
                self.selectedImage = image
            }, onCancel: {
                self.isUploadSheet = false
            }).edgesIgnoringSafeArea(.bottom)
        }
        
        .onAppear {
            self.name = vm.studentDetails?.studentname ?? ""
            self.email = vm.studentDetails?.email ?? ""
            self.phoneNumber = vm.studentDetails?.phonenumber ?? ""
            self.collegeName = vm.studentDetails?.universityname ?? ""
            self.location = vm.studentDetails?.studentlocation ?? ""
            if let loadedImage = vm.loadImageFromUserDefaults(key: "profileImage") {
                selectedImage = loadedImage
                print("Image loaded!")
            }
        }
    }
}

#Preview {
    ProfileDetailView().environmentObject(StudentViewModel())
}

struct UniversityProfileDetailView: View {
    @EnvironmentObject var vm : FacultyViewModel
    @State var name: String = ""
    @State var email: String = ""
    @State var phoneNumber: String = ""
    @State var location: String = ""
    @State var collegeName: String = ""
    @State var year: String = "2024"
    var body: some View {
        ZStack{
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing: 20){
                    BackButtonView(fontSize: 22)
                    Text("Profile")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                }
                
                AsyncImage(url: URL(string: "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg")) { image in
                    image.resizable()
                } placeholder: {
                    Image("user_placeholder").resizable()
                }.frame(width: 160, height: 160)
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .frame(width: .screen24Width, alignment: .center)
                
//                Image("user_placeholder").resizable()
//                    .frame(width: 160, height: 160)
//                    .overlay(alignment: .bottomTrailing, content: {
//                        Image(systemName: "pencil.circle.fill").resizable()
//                            .frame(width: 40, height: 40)
//                            .foregroundColor(.blue31)
//                    }).frame(width: .screen24Width, alignment: .center)
                
                VStack(alignment: .leading, spacing: 5) {
                    AnimatedTextField(text: $name, placeholder: "Name")
                    
                    AnimatedTextField(text: $collegeName, placeholder: "College Name")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "arrowtriangle.down.circle")
                        })
                    
                    AnimatedTextField(text: $phoneNumber, placeholder: "Mobile Number")
                        .disabled(true)
                    
                    AnimatedTextField(text: $email, placeholder: "Email Address")
                        .disabled(true)
                    
                    AnimatedTextField(text: $location, placeholder: "Location")
                    
                    AnimatedTextField(text: $year, placeholder: "Passed Out Year")
                        .overlay(alignment: .trailing, content: {
                            Image(systemName: "arrowtriangle.down.circle")
                        })
                }.disabled(true)
                
                Spacer(minLength: 0)
                
               
                Text("Save")
                    .customButtonStyle(textColor: .anyWhite, fontSize: 18, fontName: .generalSansSemiBold, bgColor: .blue31, width: .screen24Width, height: 55, shape: RoundedRectangle(cornerRadius: 16), shadowRadius: 1.0)
                    .onTapGesture {
                        self.vm.isSavedAccount = true
//                        let params: [String: String] = ["email": email,
//                                                        "phonenumber": phoneNumber,
//                                                        "studentname": name,
//                                                        "studentlocation": location,
//                                                        "universityname": collegeName
//                                                       ]
//                        self.vm.postRequest(endPoint: .createStudent, params: params)
                    }
                    .navigationDestination(isPresented: $vm.isSavedAccount, destination: {
                        StudentTabView(selectedIndex: 3).navigationBarBackButtonHidden()
                    })
            }.padding(.horizontal).background(.anyWhite)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
        .onAppear {
            self.name = "Anudee Varma"
            self.email = "anudee.varama@uol.co"
            self.phoneNumber = "+103231231"
            self.collegeName = "University of London"
            self.location = "London"
        }
    }
}

#Preview {
    ProfileDetailView().environmentObject(StudentViewModel())
}
