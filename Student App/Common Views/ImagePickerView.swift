//
//  ImagePickerView.swift
//  Student App
//
//  Created by tmjadmin on 10/11/24.
//

import SwiftUI
import MobileCoreServices
import UIKit

enum SourceType {
    case camera
    case photoLibrary
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage, URL) -> Void
    var onCancel: () -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.allowsEditing = false
        picker.mediaTypes = ["public.image"]
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent:ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true) {
                if(picker.sourceType == .camera) {
                    picker.stopVideoCapture()
                }
                guard let image = info[.originalImage] as? UIImage, let image_url = info[.imageURL] as? URL else { return }
                self.parent.onImagePicked(image, image_url)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
        }
    }
    
}

//struct ImagePreview: View {
//    let url: URL
//    var body: some View {
//        Image(uiImage: UIImage(contentsOfFile: url.path)!)
//            .resizable()
//            .scaledToFill()
//            .frame(width: 100, height: 100, alignment: .center)
//            .background(Color.anyWhite)
//            .clipShape(Circle())
//            .shadow(radius: 5)
//    }
//}

struct ImagePreview: UIViewRepresentable {
    var image: UIImage
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = image
    }
}
