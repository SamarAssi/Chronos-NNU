//
//  AuthenticationClient.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import Foundation
import Alamofire

class AuthenticationClient: BaseClient {

    static func login(
        email: String,
        password: String
    ) async throws -> LoginResponse {
        let router: AuthenticationRouter = .login(username: email, password: password)
        return try await performRequest(router: router)
    }

    static func onboardingManager(
        name: String,
        description: String
    ) async throws -> ManagerOnboardingResponse {
        let router: AuthenticationRouter = .onboardingManager(name: name, description: description)
        return try await performRequest(router: router)
    }

    static func onboardingEmployee(
        id: String
    ) async throws -> OnboardingEmployeeRespone {
        let router: AuthenticationRouter = .onboardingEmployee(id: id)
        return try await performRequest(router: router)
    }

    static func register(
        textFields: [TextFieldModel]
    ) async throws -> LoginResponse {
        let router: AuthenticationRouter = .registration(
            firstName: textFields[0].text,
            lastName: textFields[1].text,
            username: textFields[2].text,
            password: textFields[4].text
        )
        return try await performRequest(router: router)
    }
}
