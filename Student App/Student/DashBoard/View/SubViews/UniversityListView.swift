//
//  UniversityListView.swift
//  Student App
//
//  Created by tmjadmin on 09/11/24.
//

import SwiftUI

struct UniversityListView: View {
    @EnvironmentObject var vm : StudentViewModel
    @State var pageTitle: String
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
            ]
    var body: some View {
        ZStack(alignment: .topLeading){
            Color.white252.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 20){
                HStack(spacing: 20){
                    BackButtonView(fontSize: 22)
                    Text(pageTitle)
                        .customLabelStyle(textColor: .black50, fontSize: 22, fontName: .generalSansMedium)
                }
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(vm.allUniversity, id: \.self){ data in
                        NavigationLink(destination: BookSlotView(data: data).environmentObject(vm).navigationBarBackButtonHidden(), label: {
                            RecommendedUniversityCell(data: data).environmentObject(vm)
                                .frame(width: .screen48Width/2)
                        })
                    }
                }
                
            } .padding(.horizontal)
            
        }
    }
}

#Preview {
    UniversityListView(pageTitle: "Recommended Universities")
}
