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
    var body: some View {
        ZStack{
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing: 20){
                    BackButtonView(fontSize: 22)
                    Text("Profile")
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                }
                
                Image("user_placeholder").resizable()
                    .frame(width: 160, height: 160)
                    .overlay(alignment: .bottomTrailing, content: {
                        Image(systemName: "pencil.circle.fill").resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue31)
                    })
                    
                
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
        .onAppear {
            self.name = vm.studentDetails?.studentname ?? ""
            self.email = vm.studentDetails?.email ?? ""
            self.phoneNumber = vm.studentDetails?.phonenumber ?? ""
            self.collegeName = vm.studentDetails?.universityname ?? ""
            self.location = vm.studentDetails?.studentlocation ?? ""
        }
    }
}

#Preview {
    ProfileDetailView()
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
                
                Image("user_placeholder").resizable()
                    .frame(width: 160, height: 160)
                    .overlay(alignment: .bottomTrailing, content: {
                        Image(systemName: "pencil.circle.fill").resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue31)
                    })
                    
                
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
    ProfileDetailView()
}
