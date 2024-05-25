//
//  AvailabilityModel.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Foundation


class AvailabilityModel: ObservableObject {
    @Published var response: AvailabilityResponse?

    @MainActor
    func handleAvailabilityResponse() {
        Task {
            do {
                response = try await performLoginRequest()
            } catch let error {
                print(error)
            }
        }
    }

    private func performLoginRequest() async throws -> AvailabilityResponse {
        return try await AuthenticationClient.availability()
    }
}
