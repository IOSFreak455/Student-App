//
//  FacultyLoginViewModel.swift
//  Student App
//
//  Created by Arjun   on 14/07/24.
//

import Foundation

class FacultyLoginViewModel: ObservableObject {
    // Loading & Toast Message
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage: String? = nil
    @Published var toastType: ToastType = .info
    
    @Published var isTabPageView: Bool = false
    @Published var isForgotPassword: Bool = false
    
    init(){
        
    }
    
    func validateFacultyLogin(userName: String, password: String) {
        self.isLoading = true
        if userName == "rep123@gmail.com" && password == "rep123" {
            self.isLoading = false
            self.isTabPageView = true
            return
        } else if userName != "rep123@gmail.com"{
            self.isLoading = false
            self.showToastMessage("Please enter register emailId..!", type: .error)
            return
        } else if password != "rep123" {
            self.isLoading = false
            self.showToastMessage("Please enter correct password..!", type: .error)
            return
        }
    }
    
    func getRequest(endPoint: EndPoints, params: [String: String]) {
        guard let url = URL(string: APIUrls.baseUrl+endPoint.rawValue) else {
            showToastMessage("Invalid URL", type: .error)
            isLoading = false
            return
        }
        
        NetworkManager.shared.getRequest(url: url, params: params) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let (data, response)):
                    do {
                        if response.statusCode == 200 {
//                            let decoder = JSONDecoder()
//                            let responseModel = try decoder.decode(.self, from: data!)
//                            print("LoginViewModel: \(responseModel)")
                        } else {
                            self.showToastMessage("Some thing went wrong", type: .error)
                        }
                    } catch {
                        self.toastMessage = error.localizedDescription
                    }
                case .failure(let error):
                    self.toastMessage = error.localizedDescription
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
                        if endPoint == .authenticate {
                            if statusCode == 200 {
                                self.isTabPageView = true
                            }
                        } else if endPoint == .forgotPasword {
                            let model = try JSONDecoder().decode(ForgotPasswordModel.self, from: data!)
                            if model.userExists {
                                self.showToastMessage(model.message, type: .success)
                            } else {
                                self.showToastMessage(model.message, type: .error)
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
