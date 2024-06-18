//
//  EmployeesRouter.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation
import Alamofire

enum EmployeesRouter: BaseRouter {
    
    case getEmployees
    case registerEmployee(
        firstName: String,
        lastName: String,
        username: String,
        phone: String,
        employeeDetails: LoginResponse.EmployeeDetails,
        password: String
    )
    case deleteEmployee(username: String)
    case updateEmployeeJobs(employeeId: String, jobs: [String])
    
    var path: String {
        switch self {
        case .getEmployees:
            return "manager/getEmployees"
        case .registerEmployee:
            return "manager/registerEmployee"
        case .deleteEmployee:
            return "manager/deleteEmployee"
        case .updateEmployeeJobs:
            return "manager/updateEmployeeJobs"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getEmployees:
            return .get
        case .registerEmployee:
            return .post
        case .deleteEmployee:
            return .post
        case .updateEmployeeJobs:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getEmployees:
            return nil
        case .registerEmployee(
            let firstName,
            let lastName,
            let username,
            let phone,
            let employeeDetails,
            let password
        ):
            let employeeDetailsJson = employeeDetails.encodeToDictionary()
            
            return [
                "firstName": firstName,
                "lastName": lastName,
                "username": username,
                "phone": phone,
                "employeeDetails": employeeDetailsJson,
                "password": password
            ]
        case .deleteEmployee(let username):
            return ["username": username]
        case .updateEmployeeJobs(let employeeId, let jobs):
            return ["employeeId": employeeId, "jobs": jobs]
        }
    }
}
