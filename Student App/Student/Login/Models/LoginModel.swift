//
//  LoginModel.swift
//  Student App
//
//  Created by Arjun   on 30/09/24.
//

import Foundation

struct StudentModel: Codable {
    let id: Int?
    let universityname: String?
    let studentname: String
    let location: String?
    let studentlocation: String?
    let phonenumber: String
    let feedback: String?
    let createdatetime: String?
    let activestatus: String?
    let email: String?
}
