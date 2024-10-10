//
//  TextFieldViews.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI


struct AnimatedTextField: View {
    @Binding var text: String
    let placeholder: String
    @State private var isEditing: Bool = false
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholder)
                .customLabelStyle(textColor: .anyBlack, fontSize: 14, fontName: .generalSansRegular)
//                .scaleEffect(isEditing || !text.isEmpty ? 0.8 : 1.0)
                .offset(y: isEditing || !text.isEmpty ? -20 : 0)
                .animation(.easeInOut, value: isEditing)
            
            TextField("", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .customLabelStyle(textColor: .anyBlack, fontSize: 14, fontName: .generalSansMedium)
            .padding(.top, 15)
            .overlay(
                Rectangle().frame(height: 1).foregroundColor(isEditing ? .anyBlack : .gray153)
                    .padding(.top, 55)
            )
        }.padding(.vertical, isEditing || !text.isEmpty ? 20 : 10).animation(.easeInOut, value: text).tint(.anyBlack)
    }
}


struct SearchBar: View {
    @Binding var text: String
    var body: some View {
        
        TextField("Search", text: $text)
            .customLabelStyle(textColor: .gray153, fontSize: 16, fontName: .generalSansMedium)
            .padding(.leading, 35)
            .frame(height: 50)
            .background(Color.white248)
            .cornerRadius(10)
            .overlay(alignment: .leading, content: {
                Image(systemName: "magnifyingglass")
                    .customLabelStyle(textColor: .gray153, fontSize: 18, fontName: .generalSansSemiBold)
                    .padding(.horizontal, 8)
            })
            .tint(.anyBlack)
    }
}
