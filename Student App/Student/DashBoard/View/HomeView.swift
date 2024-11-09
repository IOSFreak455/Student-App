//
//  HomeView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm : StudentViewModel
    @State private var searchText: String = ""
    @State var isBookingSlot: Bool = false
    @Binding var selectedTab: Int
    var body: some View {
            ZStack{
                Color.white252
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    HStack{
                        Text(vm.studentDetails?.studentname.prefix(1) ?? "S")
                            .customLabelStyle(textColor: .blue31, fontSize: 22, fontName: .generalSansSemiBold)
                            .frame(width: 50, height: 50)
                            .background(Color.anyWhite)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray153, lineWidth: 2))
                            .shadow(color: .gray153, radius: 2, x: 2, y: -1)
                        Spacer()
                        SearchBar(text: $searchText)
                            .onTapGesture {
                                selectedTab = 1
                            }
                    }
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(alignment: .leading, spacing: 20){
                            HStack {
                                Text("Upcoming Appointments")
                                    .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                                Spacer(minLength: 0)
                                if vm.upComingAppos.count > 2 {
                                    Text("See all")
                                        .customLabelStyle(textColor: .green, fontSize: 16, fontName: .generalSansSemiBold)
                                        .onTapGesture {
                                            selectedTab = 2
                                        }
                                }
                            }
                            
                            if vm.upComingAppos.isEmpty {
                                ShimmerEffectView()
                                ShimmerEffectView()
                            } else {
                                ForEach(0..<(vm.upComingAppos.count > 2 ? 2 : vm.upComingAppos.count), id: \.self){ data in
                                    UniversityAppointmentCell(data: vm.upComingAppos[data])
                                }
                            }
                        }.padding(.vertical, 10)
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text("Recommended Universities")
                                .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 15){
                                    if vm.allUniversity.isEmpty {
                                        ShimmerEffectView(width: .screen48Width/2)
                                        ShimmerEffectView(width: .screen48Width/2)
                                    } else {
                                        ForEach(vm.allUniversity, id: \.self){ data in
                                            NavigationLink(destination: BookSlotView(data: data).environmentObject(vm).navigationBarBackButtonHidden(), label: {
                                                RecommendedUniversityCell(data: data).environmentObject(vm)
                                                    .frame(width: .screen48Width/2)
                                            })
                                        }
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }.frame(width: .screen24Width, alignment: .leading)
            }
        .onAppear{
            self.vm.postRequest(endPoint: .getUpcomingAppos)
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0)).environmentObject(StudentViewModel())
}
