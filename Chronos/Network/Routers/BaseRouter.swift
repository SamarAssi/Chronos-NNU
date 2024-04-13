//
//  BaseRouter.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import Foundation
import Alamofire

protocol BaseRouter: URLRequestConvertible, RequestInterceptor {
    var interceptor: RequestInterceptor? { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
}

extension BaseRouter {

    /**
     API Router: the endpoint builder
     It is important to have an API request builder component which presents an endpoint.
     The router will present an endpoint using HTTP method, HTTP headers, path and parameters
     One of the recommended approaches is to create our API router using Swift Enum.
     */

    // MARK: - Default Headers
    internal var defaultHeaders: HTTPHeaders {
        return [:]
    }

    // MARK: - Number of retry
    internal var retryLimit: Int {
        return 4
    }

    // MARK: RequestInterceptor
    internal var interceptor: RequestInterceptor? {
        return self
    }

    /**
     Alamofire has a property named RequestInterceptor.
     RequestInterceptor has two method,
     one is Adapt which assign access_token to any Network call header,
     second one is Retry method.
     In Retry method we can check response status code and call refresh_token block
     to get new token and retry previous API again.
     */

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {

        var request = urlRequest
        completion(.success(request))
    }


    /**
     Retry function.  in this function first we check that our
     retry count is less than the maximum limit which in this case is three.
     If it is greater than the maximum limit, we pass doNotRetry
     in completion else first we call another function which will refresh our token.
     In this function completion, we check that if our token has been
     refreshed successfully or not if it was successful we will retry our request
     with this newly generated token.
     */
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {

        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }

        guard request.retryCount < self.retryLimit else {
            completion(.doNotRetry)
            return
        }
        switch statusCode {
        case NetworkConstants.HttpStatusCode.success:
            completion(.doNotRetry)
            break
        case NetworkConstants.HttpStatusCode.unAuthorized:
            completion(.doNotRetry)
            break
        case NetworkConstants.HttpStatusCode.forbidden:
            completion(.doNotRetry)
            break
        default:
            completion(.doNotRetry)
            break
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.headers = self.defaultHeaders
        if let parameters = self.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(
                    withJSONObject: parameters,
                    options: [])
            } catch {
                throw AFError.parameterEncodingFailed(
                    reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
