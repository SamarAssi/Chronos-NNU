//
//  EmployeesClient.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation

class EmployeesClient: BaseClient {
    
    static func getEmployees() async throws -> EmployeesResponse {
        let router: EmployeesRouter = .getEmployees
        return try await performRequest(router: router)
    }
    
    static func registerEmployee(
        textFields: [TextFieldModel],
        employeeDetails: EmployeeDetails
    ) async throws -> LoginResponse {
        let router: EmployeesRouter = .registerEmployee(
            firstName: textFields[0].text,
            lastName: textFields[1].text,
            username: textFields[2].text,
            phone: textFields[3].text,
            employeeDetails: employeeDetails,
            password: textFields[5].text
        )
        return try await performRequest(router: router)
    }
    
    static func deleteEmployee(
        username: String
    ) async throws ->EmployeeDeletionResponse {
        let router: EmployeesRouter = .deleteEmployee(username: username)
        return try await performRequest(router: router)
    }
    
    static func updateEmployeeJobs(
        employeeId: String,
        jobs: [String]
    ) async throws -> EmployeeJobsUpdateResponse {
        let router: EmployeesRouter = .updateEmployeeJobs(
            employeeId: employeeId,
            jobs: jobs
        )
        return try await performRequest(router: router)
    }
    
    static func getEmployeeDetails(
        employeeId: String
    ) async throws -> LoginResponse {
        let router: EmployeesRouter = .getUserDetails(employeeId: employeeId)
        return try await performRequest(router: router)
    }
}
