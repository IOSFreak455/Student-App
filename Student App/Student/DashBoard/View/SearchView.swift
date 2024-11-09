//
//  SearchView.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var vm : StudentViewModel
    @State private var searchText: String = ""
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State var isFilter: Bool = false
    var body: some View {
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
                        .onTapGesture {
                            self.isFilter = true
                        }
                }
                .navigationDestination(isPresented: $isFilter, destination: {
                    HomeFilterView().environmentObject(vm).navigationBarBackButtonHidden()
                })
                
                if self.vm.searchUniversity.isEmpty {
                    VStack(alignment: .leading, spacing: 20){
                        Text(vm.recentSearches.isEmpty ? "No Recent Searches" : "Recent Searches")
                            .customLabelStyle(textColor: .black50, fontSize: 17, fontName: .generalSansMedium)
                        
                        ForEach(0..<vm.recentSearches.count, id: \.self) { id in
                            HStack{
                                Text(vm.recentSearches[id]).customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansRegular)
                                Spacer()
                                
                                Image(systemName: "xmark.circle.fill")
                                    .onTapGesture {
                                        self.vm.recentSearches.remove(at: id)
                                        self.vm.deleteRecentSearch()
                                    }
                            }
                        }
                    }.padding(.top)
                }
                
                if !self.vm.searchUniversity.isEmpty {
                    VStack(alignment: .leading, spacing: 20){
                        Text("Searche Results")
                            .customLabelStyle(textColor: .black50, fontSize: 17, fontName: .generalSansMedium)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(self.vm.searchUniversity, id: \.self){ data in
                                NavigationLink(destination: BookSlotView(data: data).environmentObject(vm).navigationBarBackButtonHidden(), label: {
                                    RecommendedUniversityCell(data: data).environmentObject(vm)
                                        .frame(width: .screen48Width/2)
                                })
                            }
                        }
                    }
                }
                Spacer(minLength: 0)
            }.frame(width: .screen24Width)
        }
        .onAppear {
            self.vm.loadRecentSearch()
        }
    }
}

#Preview {
    SearchView()
}
