//
//  NetworkRouter.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import Foundation
import Alamofire

enum NetworkRouter: URLRequestConvertible {
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
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: "https://jsonplaceholder.typicode.com/users")
        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request,with: parameters)
    }
}
