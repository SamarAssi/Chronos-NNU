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
        let router: NetworkRouter = .login(username: email, password: password)
        return try await performRequest(router: router)
    }
}
