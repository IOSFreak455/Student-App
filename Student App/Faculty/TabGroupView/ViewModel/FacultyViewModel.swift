//
//  FacultyViewModel.swift
//  Student App
//
//  Created by Arjun   on 14/07/24.
//

import Foundation

class FacultyViewModel: ObservableObject {
    // Loading & Toast Message
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage: String? = nil
    @Published var toastType: ToastType = .info
    
    @Published var allAppointments: [AllAppointmentModel] = []
    
    @Published var isSavedAccount: Bool = false
    
    init(){
        
    }
    
    func postRequest(endPoint: EndPoints) {
        self.isLoading = true
        guard let url = URL(string: APIUrls.baseUrl+endPoint.rawValue) else {
            showToastMessage("Invalid URL", type: .error)
            isLoading = false
            return
        }
        
        NetworkManager.shared.postRequest(url: url) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let (data, response)):
                    do {
                        let decoder = JSONDecoder()
                        if response.statusCode == 200 {
                            if endPoint == .getAppointmentByRepname {
                            let responseModel = try decoder.decode([AllAppointmentModel].self, from: data!)
                                self.allAppointments = responseModel
                            }
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
                        if endPoint == .giveFeedback {
                            if statusCode == 200 {
                                self.showToastMessage("Successfully submitted feedback..!", type: .success)
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
    
    private func showToastMessage(_ message: String, type: ToastType) {
        self.toastMessage = message
        self.toastType = type
        self.showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showToast = false
        }
    }
}
