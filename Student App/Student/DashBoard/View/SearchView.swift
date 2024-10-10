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
    var body: some View {
        ZStack{
            Color.white252
                .ignoresSafeArea()
            VStack(spacing: 20){
                HStack{
                    SearchBar(text: $searchText)
                    Spacer()
                    NavigationLink(destination: HomeFilterView().environmentObject(vm).navigationBarBackButtonHidden(), label: {
                    Image(systemName: "slider.horizontal.3")
                        .customLabelStyle(textColor: .blue31, fontSize: 22, fontName: .generalSansSemiBold)
                        .frame(width: 50, height: 50)
                        .background(Color.anyWhite)
                        .cornerRadius(10)
                        .shadow(color: .gray153, radius: 0.45, x: 0.3, y: 0.3)
                    })
                }
                
                VStack(alignment: .leading, spacing: 20){
                    Text("Recent Searches")
                        .customLabelStyle(textColor: .black50, fontSize: 17, fontName: .generalSansMedium)
                    
                    HStack{
                        Text("Rodger University, ")
                        + Text("California").foregroundColor(.gray64)
                        Spacer()
                        Image(systemName: "xmark.circle.fill")
                    } .customLabelStyle(textColor: .black50, fontSize: 16, fontName: .generalSansRegular)
                }.padding(.top)
                Spacer(minLength: 0)
            }.frame(width: .screen24Width)
        }
    }
}

#Preview {
    SearchView()
}
