import SwiftUI

struct Toast: Equatable {
  var style: ToastType
  var message: String
  var duration: Double = 3
  var width: Double = .infinity
}

enum ToastType: String {
  case error = "Error"
  case warning = "Warning"
  case success = "Success"
  case info = "Info"
}

extension ToastType {
  var themeColor: Color {
    switch self {
    case .error: return Color.red
    case .warning: return Color.orange
    case .info: return Color.blue
    case .success: return Color.green
    }
  }
  
  var iconFileName: String {
    switch self {
    case .info: return "info.circle.fill"
    case .warning: return "exclamationmark.triangle.fill"
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.circle.fill"
    }
  }
}


struct ToastView: View {
    var style: ToastType
    var message: String
    var width = CGFloat.screen24Width
    @Binding var isShowing: Bool
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: style.iconFileName)
                .foregroundColor(style.themeColor)
            
            Text(message)
                .customLabelStyle(textColor: .anyBlack, fontSize: 12, fontName: .generalSansRegular)
            
            Spacer(minLength: 10)
            
            Button {
                self.isShowing = false
            } label: {
                Image(systemName: "xmark.circle")
                    .foregroundColor(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(.anyWhite)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .fill(style.themeColor)
                .opacity(0.1)
        )
        .padding(.horizontal, 16)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isShowing = false
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        ToastView(
            style: .success,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isShowing: .constant(false)
        )
        ToastView(
            style: .info,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isShowing: .constant(false)
        )
        ToastView(
            style: .warning,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isShowing: .constant(false)
        )
        ToastView(
            style: .error,
            message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", isShowing: .constant(false)
        )
    }
}


