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

    static func updateCheckInOut() async throws -> CheckInOutResponse {
        let router: DashboardRouter = .checkInOut
        return try await performRequest(router: router)
    }
}