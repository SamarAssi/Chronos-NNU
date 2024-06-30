//
//  DashboardClient.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Foundation

class DashboardClient: BaseClient {

    static func dashboard(
        date: String,
        employeeId: String
    ) async throws -> DashboardResponse {
        let router: DashboardRouter = .dashboard(date: date, employeeId: employeeId)
        return try await performRequest(router: router)
    }

    static func updateCheckInOut(
        currentLatitude: Double,
        currentLongitude: Double,
        date: String
    ) async throws -> CheckInOutResponse {
        let router: DashboardRouter = .checkInOut(
            currentLatitude: currentLatitude,
            currentLongitude: currentLongitude,
            date: date
        )
        return try await performRequest(router: router)
    }
}
