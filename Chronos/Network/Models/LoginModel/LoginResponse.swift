//
//  LoginResponse.swift
//  Chronos
//
//  Created by Samar Assi on 29/04/2024.
//

import Foundation

struct LoginResponse: Hashable, Codable {
    let employeeDetails: EmployeeDetails
    let accessToken: String
    let firstName: String
    let lastName: String
    let username: String
    let phone: String
}

struct EmployeeDetails: Hashable, Codable {
    var jobs: [Job]
    var employeeType: Int
    let joinedDate: String
    let salary: Double
    let reportsTo: String
    let companyName: String?
}
