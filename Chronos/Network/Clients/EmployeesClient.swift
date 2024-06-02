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
}
