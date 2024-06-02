//
//  EmployeesResponse.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation

struct EmployeesResponse: Hashable, Codable {
    let employees: [Employee]
    
    struct Employee: Hashable, Codable {
        let id: String
        let username: String
        let firstName: String
        let lastName: String
        let jobs: [Job]
    }
}
