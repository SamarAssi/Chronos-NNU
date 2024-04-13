//
//  NetworkRouter.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import Alamofire

enum NetworkRouter: BaseRouter {
    case login
    case home
        
    var path: String {
        switch self {
        case .login:
            return "login"
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
        case .login:
            return [:]
        default:
            return nil
        }
    }
}
