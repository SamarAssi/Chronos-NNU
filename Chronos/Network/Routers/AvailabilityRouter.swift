//
//  AvailabilityRouter.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Alamofire
import Foundation

enum AvailabilityRouter: BaseRouter {

    case getAvailability
    case updateAvailability(availability: Availabilities)
    case requestsList
    case approveAvailability(id: String, comment: String)
    case rejectAvailability(id: String, comment: String)
    case availabilityChanges(id: String)

    var path: String {
        switch self {
        case .getAvailability:
            return "availability"
        case .updateAvailability:
            return "availability/requestChange"
        case .requestsList:
            return "availability/requests"
        case .approveAvailability:
            return "availability/approve"
        case .rejectAvailability:
            return "availability/reject"
        case .availabilityChanges:
            return "availability/availabilityChanges"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAvailability:
            return .get
        case .updateAvailability:
            return .post
        case .requestsList:
            return .get
        case .approveAvailability:
            return .post
        case .rejectAvailability:
            return .post
        case .availabilityChanges:
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

        case .requestsList:
            return nil

        case .approveAvailability(let id, let comment), .rejectAvailability(let id, let comment):
            return [
                "id": id,
                "comment": comment
            ]

        case .availabilityChanges(let id):
            return ["id": id]
        }
    }
}
