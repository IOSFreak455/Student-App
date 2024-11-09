//
//  StudentLoginViewModel.swift
//  Student App
//
//  Created by Arjun   on 26/08/24.
//

import Foundation
import PhotosUI

class StudentLoginViewModel: ObservableObject {
    // Loading & Toast Message
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage: String? = nil
    @Published var toastType: ToastType = .info
    
    @Published var phoneNumber: String = ""
    @Published var isUserExist: Bool = false
    
    @Published var isCreateAccount: Bool = false
    
    @Published var isCameraAccessDenied = false
    @Published var isPhotoLibraryAccessDenied = false
    
    func postQueryRequest(endPoint: EndPoints, params: [String: String]) {
        self.isLoading = true
        guard let url = URL(string: APIUrls.baseUrl+endPoint.rawValue) else {
            showToastMessage("Invalid URL", type: .error)
            isLoading = false
            return
        }
        
        NetworkManager.shared.postRequest(url: url, queryParams: params) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let (responseBool, httpResponse)):
                    if let responseBool = responseBool {
                        if endPoint == .isUserExists {
                           if responseBool && httpResponse.statusCode == 200  {
                                APIUrls.phoneNumber = self.phoneNumber
                            }
                            self.isUserExist = responseBool
                        }
                    }
                case .failure(let error as NSError):
                    self.showToastMessage(error.localizedDescription, type: .error)
                }
            }
        }
    }
    
    func postRequest(endPoint: EndPoints, params: [String: String]) {
        self.isLoading = true
        guard let url = URL(string: APIUrls.baseUrl+endPoint.rawValue) else {
            showToastMessage("Invalid URL", type: .error)
            isLoading = false
            return
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: params) else {
            showToastMessage("Failed to serialize JSON", type: .error)
            isLoading = false
            return
        }
        
        NetworkManager.shared.postRequest(url: url, body: jsonData) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let (data, response)):
                    let statusCode = response.statusCode
                    print("Response: \(response.statusCode)")
                    do {
                        if statusCode == 200 {
                            self.isCreateAccount = true
                            if !self.isCreateAccount {
                                self.showToastMessage("Please try again, error during creating account", type: .error)
                            } else {
                                APIUrls.phoneNumber = self.phoneNumber
                            }
                        }
                    } catch {
                        self.showToastMessage(error.localizedDescription, type: .error)
                    }
                case .failure(let error as NSError):
                    self.showToastMessage(error.localizedDescription, type: .error)
                }
            }
        }
    }
    
    func showToastMessage(_ message: String, type: ToastType) {
        self.toastMessage = message
        self.toastType = type
        self.showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
        }
    }
}

// Camera, PhotoLibrary
extension StudentLoginViewModel {
    func saveImageToUserDefaults(image: UIImage, key: String) {
        if let imageData = image.pngData() { // You can use jpegData() too
            UserDefaults.standard.set(imageData, forKey: key)
        }
    }

    // Function to load UIImage from UserDefaults
    func loadImageFromUserDefaults(key: String) -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: key) {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                self.isCameraAccessDenied = !granted
            }
        }
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.isPhotoLibraryAccessDenied = false
                case .denied, .restricted, .notDetermined:
                    self.isPhotoLibraryAccessDenied = true
                default:
                    break
                }
            }
        }
    }
    
    func checkInitialAccessStatus() {
        // Check camera access
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        isCameraAccessDenied = (cameraStatus == .denied || cameraStatus == .restricted)
        if isCameraAccessDenied {
            self.showToastMessage("Camera Access Denied/nPlease enable camera access in Settings.", type: .error)
            return
        }
        // Check photo library access
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        isPhotoLibraryAccessDenied = (photoStatus == .denied || photoStatus == .restricted)
        if isPhotoLibraryAccessDenied {
            self.showToastMessage("Photo Access Denied/nPlease enable media access in Settings.", type: .error)
            return
        }
    }
}
