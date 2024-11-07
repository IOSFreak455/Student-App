//
//  StudentViewModel.swift
//  Student App
//
//  Created by Arjun   on 16/07/24.
//

import SwiftUI
import Combine

class StudentViewModel: ObservableObject {
    // Loading & Toast Message
    @Published var isLoading = false
    @Published var showToast = false
    @Published var toastMessage: String? = nil
    @Published var toastType: ToastType = .info
    
    @Published var isBookAppointment: Bool = false
    @Published var upComingAppos: [AllAppointmentModel] = []
    
    @Published var repData: [Representatives] = []
    @Published var allUniversity: [University] = []
    @Published var selectedDate: Date = Date()
    @Published var bookSlot: BookAppoDetailsModel = BookAppoDetailsModel(
        appointmentDate: "",
        appointmentSlot: "",
        location: "",
        repData: .init(image: "", repname: ""),
        studentName: "",
        universityName: "",
        rankName: "",
        phoneNumber: ""
    )
    
    @Published var selectedCountry: [String] = []
    let countries = ["USA", "UK", "London", "Canada", "Australia"]
    
    @Published var selectedState: [String] = []
    let states = ["Georgia", "South Dakota", "Ohio", "Michigan"]
    
    @Published var selectedCourse: [String] = []
    let courseType = ["Masters", "Bachelors", "PG Diploma"]
    
    @Published var selectedAppointments: [String] = []
    let appointments = ["Available Open Slots"]
    
    //Slots
    @Published var morningSlots: [String] = []
    @Published var afterSlots: [String] = []
    @Published var eveningSlots: [String] = []
    
    @Published var studentDetails: StudentModel?
    
    @Published var isSavedAccount: Bool = false
    
    init(){
        self.postQueryRequest(endPoint: .getStudentDetailsByMobileNumber, params: ["phoneNumber": APIUrls.phoneNumber])
        loadSlots()
    }
    
    func load(from urls: [String]) async -> [UIImage?] {
        var images: [UIImage?] = Array(repeating: nil, count: urls.count)
        
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (index, urlString) in urls.enumerated() {
                group.addTask {
                    guard let url = URL(string: urlString) else { return (index, nil) }
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        let uiImage = UIImage(data: data)
                        return (index, uiImage)
                    } catch {
                        return (index, Image("one").asUIImage()) // Handle error and return nil
                    }
                }
            }
            
            for await (index, uiImage) in group {
                images[index] = uiImage
            }
        }
        
        return images
    }
    
    func postQueryRequest(endPoint: EndPoints, params: [String: String]) {
        self.isLoading = true
        guard let url = URL(string: APIUrls.baseUrl+endPoint.rawValue) else {
            showToastMessage("Invalid URL", type: .error)
            isLoading = false
            return
        }
        
        NetworkManager.shared.postRequest(url: url, paramsQuery: params, isFrom: true) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let (data, response)):
                    do {
                        let decoder = JSONDecoder()
                        if response.statusCode == 200 {
                            if endPoint == .getStudentDetailsByMobileNumber {
                                let responseModel = try decoder.decode([StudentModel].self, from: data!)
                                self.studentDetails = responseModel.first
                            }
                        } else {
                            self.showToastMessage("Some thing went wrong", type: .error)
                        }
                    }  catch {
                        self.toastMessage = error.localizedDescription
                    }
                case .failure(let error as NSError):
                    self.showToastMessage(error.localizedDescription, type: .error)
                }
            }
        }
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
                            if endPoint == .getUpcomingAppos {
                                let responseModel = try decoder.decode([AllAppointmentModel].self, from: data!)
                                self.upComingAppos = responseModel
                                self.postRequest(endPoint: .getAllUniversity)
                            } else if endPoint == .getAllUniversity {
                            let responseModel = try decoder.decode(AllUniversity.self, from: data!)
                                self.allUniversity = responseModel.universities
                                self.postRequest(endPoint: .getRepnames)
                            } else if endPoint == .getRepnames {
                                let repModel = try decoder.decode([Representatives].self, from: data!)
                                self.repData = repModel
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
                    do {
                        if statusCode == 200 {
                            if endPoint == .authenticate {
                                
                            } else if endPoint == .forgotPasword {
                                let model = try JSONDecoder().decode(ForgotPasswordModel.self, from: data!)
                                if model.userExists {
                                    self.showToastMessage("You account exist, a rest link is on its way", type: .success)
                                } else {
                                    self.showToastMessage("Email not Found, Please contact support team", type: .error)
                                }
                            } else if endPoint == .createStudent {
                                self.isSavedAccount = true
                                if !self.isSavedAccount {
                                    self.showToastMessage("Please try again, error during creating account", type: .error)
                                } else {
                                    self.postRequest(endPoint: .getAllStudents)
                                }
                            } else if endPoint == .bookAppointment {
                                self.isBookAppointment = true
                                self.showToastMessage("Sucessfully booked appointment...!", type: .success)
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
    
    // To Send Post Request In Model Formate
    func sendPostRequest<T: Encodable>(endPoint: EndPoints, params: T) {
        self.isLoading = true
        guard let url = URL(string: APIUrls.baseUrl+endPoint.rawValue) else {
            showToastMessage("Invalid URL", type: .error)
            isLoading = false
            return
        }
        
        NetworkManager.shared.sendPostRequest(to: url, with: params) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let (data, response)):
                    guard data != nil else {
                        self.showToastMessage("No data in response in reschedule booking", type: .info)
                        return
                    }
                    do {
                        print(url, params)
                        if response.statusCode == 200 {
                            if endPoint == .bookAppointment {
                                self.isBookAppointment = true
                                self.showToastMessage("Sucessfully booked appointment...!", type: .success)
                            }
                        } else {
                            self.showToastMessage("Please try after some time..!", type: .error)
                        }
                    }
                case .failure(let error):
                    self.toastMessage = error.localizedDescription
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
    
    func getSlots() {
        
    }
    
    func loadSlots() {
        morningSlots = [ "08:00 - 09:00", "09:00 - 10:00", "10:00 - 11:00", "11:00 - 12:00", "12:00 - 01:00"]
        
        afterSlots = ["03:00 - 04:00", "04:00 - 05:00", "05:00 - 06:00"]
        
        eveningSlots = ["06:00 - 07:00", "07:00 - 08:00"]
    }
}


extension Image {
    func asUIImage() -> UIImage? {
        // Create a hosting controller to get the UIImage
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        // Render the view into a UIImage
        let renderer = UIGraphicsImageRenderer(size: view?.bounds.size ?? CGSize.zero)
        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}
