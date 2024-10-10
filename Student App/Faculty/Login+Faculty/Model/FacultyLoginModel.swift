//
//  FacultyLoginModel.swift
//  Student App
//
//  Created by Arjun   on 14/07/24.
//

import Foundation

struct ForgotPasswordModel: Codable {
  var message: String
  var resetLink: String?
  var userExists: Bool
}
