//
//  AvailabilityClient.swift
//  Chronos
//
//  Created by Bassam Hillo on 25/05/2024.
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
}
