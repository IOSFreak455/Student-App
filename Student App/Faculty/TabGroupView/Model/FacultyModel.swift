//
//  FacultyModel.swift
//  Student App
//
//  Created by Arjun   on 25/07/24.
//

import Foundation

struct AllAppointmentModel: Codable, Hashable {
    let id: Int
    let universityname, studentname, location, repname: String?
    let appointmentdate, appointmentslot: String?
    let createdatetime: String
    let pass_out_year: String?
    let category: String?
    let mailId: String?
}
