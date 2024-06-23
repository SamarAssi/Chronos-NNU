//
//  AvailabilityClient.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Foundation

class AvailabilityClient: BaseClient {

    static func getAvailability() async throws -> Availabilities {
        let router: AvailabilityRouter = .getAvailability
        return try await performRequest(router: router)
    }

    static func updateAvailability(
        availability: Availabilities
    ) async throws -> Availabilities {
        let router: AvailabilityRouter = .updateAvailability(availability: availability)
        return try await performRequest(router: router)
    }

    static func availabilityRequestsList() async throws -> AvailabilityRequestsListResponse {
        let router: AvailabilityRouter = .requestsList
        return try await performRequest(router: router)
    }

    static func approveAvailabilityRequest(
        id: String,
        comment: String
    ) async throws -> AvailabilityApprovalResponse {
        let router: AvailabilityRouter = .approveAvailability(id: id, comment: comment)
        return try await performRequest(router: router)
    }

    static func rejectAvailabilityRequest(
        id: String,
        comment: String
    ) async throws -> AvailabilityApprovalResponse {
        let router: AvailabilityRouter = .rejectAvailability(id: id, comment: comment)
        return try await performRequest(router: router)
    }

    static func getAvailabilityChangeRequest(id: String) async throws -> AvailabilityUpdateRequestResponse {
        let router: AvailabilityRouter = .availabilityChanges(id: id)
        return try await performRequest(router: router)
    }
}
