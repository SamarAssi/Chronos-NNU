//
//  NetworkConstants.swift
//  Chronos
//
//  Created by Bassam Hillo on 13/04/2024.
//

import Foundation

struct NetworkConstants {

    struct HTTPHeaderField  {
        static let authentication = "Authorization"
        static let contentType = "Content-Type"
        static let acceptType = "Accept"
        static let acceptEncoding = "Accept-Encoding"
        static let channel = "Channel"
        static let lang = "Lang"
        static let deviceID = "DeviceID"
        static let mobileApp = "MobileApp"
        static let accessToken = "Access-Token"
        static let refreshToken = "Refresh-Token"
        static let switchToken = "Switch-Token"
    }

    struct ContentType  {
        static let json = "application/json"
    }

    enum HttpStatusCode {
        /**
         200, OK: Success and Failed requests.
         400, bad request: missing or invalid parameters.
         401, Not Authorized: Expired Token, needs to refresh tokens (Refresh + Access-Token) again.
         403, Forbidden: Token is not valid anymore, Login must occur.
         500, Server Error: Any Internal Server Error.
         */
        static let success = 200...299
        static let badRequest = 400
        static let unAuthorized = 401
        static let forbidden = 403
        static let internalServerError = 500
    }
}
