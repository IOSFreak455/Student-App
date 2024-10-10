//
//  Constants+API's.swift
//  Student App
//
//  Created by Arjun   on 14/07/24.
//

import Foundation

enum EndPoints: String {
    // Login Controller
    case authenticate = "authenticate"
    case forgotPasword = "forgotPassword"
    case resetPassword = "resetPassword"
    
    // Appointment Controller
    case bookAppointment = "bookAppointment"
    case getAllAppointments = "getAllAppointments"
    case getAppointmentDetailsByID = "getAppointmentDetailsByID"
    case getAppointmentsByID = "getAppointmentsByID"
    case getAppointmentByRepname = "getAppointmentsByRepname"
    case getAppointmentsWithByMN = "getAppointmentsWithMobileNumber"
    case getUpcomingAppos = "getUpcomingAppointments"
    
    // Representative Controller
    case getAuthenticateRep = "authenticateRep"
    case getAllRepresentatives = "getAllRepresentatives"
    case getRepresentativeAppointmentsByEmailID = "getRepresentativeAppointmentsByEmailID"
    
    // Student Controller
    case createStudent = "createStudent"
    case getAllStudents = "getAllStudents"
    case getStudentDetailsByMobileNumber = "getStudentDetailsByMobileNumber"
    case giveFeedback = "giveFeedback"
    case isUserExists = "isUserExists"
    case studentDetails = "studentDetails"
    
    // University Controller
    case addUniversity = "addUniversity"
    case getAllUniversity = "getAllUniversities"
    case getRepnames = "getRepresentatives"
    case getUniversitiesByID = "getUniversitiesByID"
    case getUniversityByRepname = "getUniversitiesByRepName"
    case getImages = "images/{filename}"
    case searchUniversity = "searchUniversity"
}

struct APIUrls  {
    
    static let baseUrl: String = "https://universitystudentapp.onrender.com/api/"
    
    static func abbreviate(_ name: String) -> String {
        let words = name.split(separator: " ")
        let initials = words.map { $0.first }.compactMap { $0 }
        return String(initials)
    }
    
    static var phoneNumber: String = ""
    
    static var isStudent: Bool = false
    
    static let urlImages: [String] = ["https://img.freepik.com/premium-photo/journey-through-heart-large-university-campus-with-main-building-generative-ai_634358-1178.jpg,https://img.freepik.com/free-photo/harvard-university-cambridge-usa_1268-14363.jpg",
        "https://img.freepik.com/premium-photo/journey-through-heart-large-university-campus-with-main-building-generative-ai_634358-1178.jpg,https://img.freepik.com/free-photo/harvard-university-cambridge-usa_1268-14363.jpg"]
}



