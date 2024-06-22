//
//  OnboardingClient.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import Foundation

class OnboardingClient: BaseClient {
    
    static func getCompanyLocation() async throws -> OnboardingCompanyResponse {
        let router: OnboardingRouter = .getIgnoreCheckInOutLocationValue
        return try await performRequest(router: router)
    }
    
    static func updateCompanyRules(
        companyName: String,
        about: String,
        latitude: Double,
        longitude: Double,
        allowedRadius: Double,
        ignoreCheckInLocation: Bool
    ) async throws -> UpdateCompanyRulesResponse {
        let router: OnboardingRouter = .updateCompanyRules(
            companyName: companyName,
            about: about,
            latitude: latitude,
            longitude: longitude,
            allowedRadius: allowedRadius,
            ignoreCheckInLocation: ignoreCheckInLocation
        )
        return try await performRequest(router: router)
    }
}
