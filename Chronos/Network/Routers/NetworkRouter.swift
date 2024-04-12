//
//  NetworkRouter.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import Foundation
import Alamofire

extension ChronosURLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: URLString)
        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request,with: parameters)
    }
}

enum NetworkRouter: ChronosURLRequestConvertible {
    case login
    case home
    
    var URLString: String {
        switch self {
        case .login:
            return "https://jsonplaceholder.typicode.com/users"
        case .home:
            return "https://jsonplaceholder.typicode.com/users"
        }
    }
    
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
