//
//  AvailabilityRouter.swift
//  Chronos
//
//  Created by Bassam Hillo on 25/05/2024.
//

import Alamofire
import Foundation

enum AvailabilityRouter: BaseRouter {

    case getAvailability
    case updateAvailability(availability: Availabilities)

    var path: String {
        switch self {
        case .getAvailability:
            return "availability"
        case .updateAvailability:
            return "availability/requestChange"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAvailability:
            return .get
        case .updateAvailability(availability: let availability):
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
            case .getAvailability:
                return nil

            case .updateAvailability(availability: let availability):
                let encoder = JSONEncoder()
                let data = try? encoder.encode(availability)
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                return json as? Parameters
        }
    }
}
