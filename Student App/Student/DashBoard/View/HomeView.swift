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
    var body: some View {
//        LoadingView(isLoading: $vm.isLoading){
            ZStack{
                Color.white252
                    .ignoresSafeArea()
                VStack(spacing: 20){
                    HStack{
                        SearchBar(text: $searchText)
                        Spacer()
                        Image(systemName: "slider.horizontal.3")
                            .customLabelStyle(textColor: .blue31, fontSize: 22, fontName: .generalSansSemiBold)
                            .frame(width: 50, height: 50)
                            .background(Color.anyWhite)
                            .cornerRadius(10)
                            .shadow(color: .gray153, radius: 0.45, x: 0.3, y: 0.3)
                    }
                    
                    ScrollView(.vertical, showsIndicators: false){
                        VStack(alignment: .leading, spacing: 20){
                            Text("Upcoming Appointments")
                                .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                                .frame(width: .screen24Width, alignment: .leading)
                            if vm.upComingAppos.isEmpty {
                                ShimmerPlaceholder()
                                ShimmerPlaceholder()
                            } else {
                                ForEach(vm.upComingAppos, id: \.self){ data in
                                    UniversityAppointmentCell(data: data)
                                }
                            }
                        }
                        
                        .padding(.vertical, 10)
                        VStack(alignment: .leading, spacing: 10){
                            Text("Recommended Universities")
                                .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansSemiBold)
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 15){
                                    if vm.upComingAppos.isEmpty {
                                        ShimmerPlaceholder(width: .screen48Width/2)
                                        ShimmerPlaceholder(width: .screen48Width/2)
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
//        }
        .onAppear{
            self.vm.postRequest(endPoint: .getUpcomingAppos)
        }
    }
}

#Preview {
    HomeView().environmentObject(StudentViewModel())
}
