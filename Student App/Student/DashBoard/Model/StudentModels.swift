//
//  StudentModels.swift
//  Student App
//
//  Created by Arjun   on 20/07/24.
//

import Foundation

// MARK: - AllUniversity
struct AllUniversity: Codable {
    let universities: [University]
    let status, message: String?
}

struct University: Codable, Identifiable, Hashable {
    let id: Int
    let universityname, description, location, repname: String
    let position, admissionintake, username, password: String
    let images: String?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: University, rhs: University) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Representatives: Codable, Hashable {
    let image: String
    let repname: String
}

struct BookAppoDetailsModel: Codable, Equatable {
    var appointmentDate: String
    var appointmentSlot: String
    var location: String
    var repData: Representatives
    var studentName: String
    var universityName: String
    var rankName: String
    var phoneNumber: String
}
