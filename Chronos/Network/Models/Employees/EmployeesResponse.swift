//
//  EmployeesResponse.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import SwiftUI

struct EmployeesResponse: Hashable, Codable {
    let employees: [Employee]
}

struct Employee: Hashable, Identifiable, Codable {
    let id: String
    let username: String
    let firstName: String
    let lastName: String
    let phone: String
    let jobs: [Job]
}
