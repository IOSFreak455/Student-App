//
//  ActivityIndicatorView.swift
//  Chargin
//
//  Created by Arjun  on 13/07/24.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingView<Content>: View where Content: View {
    @Binding var isLoading: Bool
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
                .disabled(isLoading)
                .blur(radius: isLoading ? 0.2 : 0)

            if isLoading {
                VStack {
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                        .tint(.anyBlack)
                    Text("Loading...")
                        .customLabelStyle(textColor: .anyBlack, fontSize: 16, fontName: .generalSansMedium)
                }
            }
        }
    }
}

struct ShimmerPlaceholder: View {
    @State private var gradientAnimation = false
    var width: CGFloat = .screen24Width
    var height: CGFloat = 140

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.gray.opacity(0.3))
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.7), Color.white.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .mask(
                        RoundedRectangle(cornerRadius: 10)
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: gradientAnimation ? width : -width)
                    .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: gradientAnimation)
            )
            .onAppear {
                gradientAnimation = true
            }
            .frame(width: width, height: height)
    }
}

struct ShimmerEffectView: View {
    @State private var animateShimmer = false
    var width: CGFloat = .screen24Width
    var height: CGFloat = 140
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: width, height: height)
                .mask(RoundedRectangle(cornerRadius: 20)) // Optional masking for rounded corners
                .overlay(
                    Rectangle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.6), Color.white.opacity(0.3)]), startPoint: .leading, endPoint: .trailing))
                        .frame(width: 50, height: height+10)
                        .rotationEffect(.degrees(10))
                        .offset(x: animateShimmer ? 500 : -500)
                        .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: animateShimmer)
                )
                .onAppear {
                    animateShimmer = true
                }
        }
    }
}
