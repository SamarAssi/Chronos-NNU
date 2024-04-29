//
//  NetworkRouter.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import Alamofire

enum NetworkRouter: BaseRouter {
    case login(username: String, password: String)
    case home

    var path: String {
        switch self {
        case .login:
            return "https://timeshift-420211.ew.r.appspot.com/auth/login"
        case .home:
            return "home"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .home:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return ["username": username, "password": password]
        default:
            return nil
        }
    }
}
