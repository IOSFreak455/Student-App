//
//  View+Entension+Modifier.swift
//  Student App
//
//  Created by Arjun   on 12/07/24.
//


import SwiftUI

// Label
struct CustomLabelModifier: ViewModifier {
    var textColor: Color
    var fontSize: CGFloat
    var fontName: String
    
    func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
            .foregroundColor(textColor)
    }
}

extension View {
    func customLabelStyle(textColor: Color, fontSize: CGFloat, fontName: String) -> some View {
        self.modifier(CustomLabelModifier(textColor: textColor, fontSize: fontSize, fontName: fontName))
    }
}

// Button
struct CustomButtonViewModifier<ShapeType: Shape>: ViewModifier {
    var textColor: Color
    var fontSize: CGFloat
    var fontName: String
    var bgColor: Color
    var width: CGFloat
    var height: CGFloat
    var shape: ShapeType
    var shadowRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .frame(width: width, height: height)
            .font(.custom(fontName, size: fontSize))
            .foregroundColor(textColor)
            .background(bgColor)
            .clipShape(shape)
            .shadow(radius: shadowRadius)
        
    }
}

extension View {
    func customButtonStyle<ShapeType: Shape>(textColor: Color, fontSize: CGFloat, fontName: String, bgColor: Color, width: CGFloat, height: CGFloat, shape: ShapeType, shadowRadius: CGFloat) -> some View {
        self.modifier(CustomButtonViewModifier(textColor: textColor, fontSize: fontSize, fontName: fontName, bgColor: bgColor, width: width, height: height, shape: shape, shadowRadius: shadowRadius
        ))
    }
}
