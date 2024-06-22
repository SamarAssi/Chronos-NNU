//
//  DashboardClient.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Foundation

class DashboardClient: BaseClient {

    static func dashboard(
        date: Int
    ) async throws -> DashboardResponse {
        let router: DashboardRouter = .dashboard(date: date)
        return try await performRequest(router: router)
    }

    static func updateCheckInOut(
        currentLatitude: Double,
        currentLongitude: Double
    ) async throws -> CheckInOutResponse {
        let router: DashboardRouter = .checkInOut(
            currentLatitude: currentLatitude,
            currentLongitude: currentLongitude
        )
        return try await performRequest(router: router)
    }
}
