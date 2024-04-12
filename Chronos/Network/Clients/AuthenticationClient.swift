//
//  AuthenticationClient.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import Foundation
import Alamofire

class AuthenticationClient: BaseClient {
    static func login() async throws -> [UserModel] {
        let router: NetworkRouter = .home
        return try await performRequest(router: router)
    }
}
