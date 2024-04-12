//
//  BaseRouter.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible {
    var URLString: String  { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

extension BaseRouter {
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: URLString)
        var request = URLRequest.init(url: url!)
        request.httpMethod = method.rawValue
        request.timeoutInterval = TimeInterval(10 * 1000)
        return try URLEncoding.default.encode(request,with: parameters)
    }
}
