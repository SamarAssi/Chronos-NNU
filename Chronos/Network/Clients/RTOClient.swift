//
//  RTOClient.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import Foundation

class RTOClient: BaseClient {

    static func createPTO(
        type: String,
        isFullDay: Bool,
        startDate: Date,
        endDate: Date,
        description: String
    ) async throws ->  UpdateCompanyRulesResponse {
        let router = RTORouter.createPTO(
            type: type,
            isFullDay: isFullDay,
            startDate: startDate,
            endDate: endDate,
            description: description
        )
        return try await performRequest(router: router)
    }

    static func getTimeOffRequests() async throws -> TimeOffRequests {
        let router = RTORouter.getRequests
        return try await performRequest(router: router)
    }

    static func updateTimeOffStatus(
        status: Int,
        timeOffId: String,
        comment: String?
    ) async throws -> TimeOffRequests  {
        let router = RTORouter.updateTimeOffStatus(
            status: status,
            timeOffId: timeOffId,
            comment: comment
        )
        return try await performRequest(router: router)
    }

    static func deleteRequest(timeOffId: String) async throws -> TimeOffRequests {
        let router = RTORouter.deleteRequest(timeOffId: timeOffId)
        return try await performRequest(router: router)
    }
}
