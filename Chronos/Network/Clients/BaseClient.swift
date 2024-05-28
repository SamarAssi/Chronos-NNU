//
//  BaseClient.swift
//  Chronos
//
//  Created by Samar Assi on 12/04/2024.
//

import Alamofire

protocol NetworkClientProtocol: AnyObject {
    static func performRequest<T: Decodable> (router: BaseRouter) async throws -> T
}

class BaseClient: NetworkClientProtocol {

    /// Performs a network request using Alamofire and a specified router.
    ///
    /// This asynchronous method sends a request using Alamofire with the details specified in the `router` parameter.
    /// It waits for the response and then either returns the decoded data or throws an error if the request fails.
    /// The method uses Swift's concurrency features (`async/throws`) to handle the network response.
    ///
    /// - Parameters:
    ///   - router: A `BaseRouter` object that provides the URL,
    ///             HTTP method, parameters, headers, etc., for the network request.
    /// - Returns: A value of type `T`, where `T` is a `Decodable`
    ///             type that represents the data returned from the request.
    /// - Throws: An `Error` if the request fails.
    @discardableResult
    internal static func performRequest<T: Decodable> (router: BaseRouter) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                router,
                interceptor: router.interceptor
            )
            .validate()
            .responseDecodable { (response: DataResponse<T, AFError>) in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
