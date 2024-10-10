//
//  ButtonViews.swift
//  Student App
//
//  Created by Arjun   on 13/07/24.
//

import SwiftUI

struct BackButtonView: View {
    @State var fontSize: CGFloat?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Image(systemName: "arrow.left")
            .customLabelStyle(textColor: .gray64, fontSize: fontSize ?? 18, fontName: .generalSansSemiBold)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
}

#Preview {
    BackButtonView()
}
