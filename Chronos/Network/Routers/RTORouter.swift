//
//  RTORouter.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import Foundation
import Alamofire

enum RTORouter: BaseRouter {

    case createPTO(
        type: String,
        isFullDay: Bool,
        startDate: Date,
        endDate: Date,
        description: String
    )
    case getRequests

    var path: String {
        switch self {
        case .createPTO:
            return "timeOff/addTimeOffRequest"
        case .getRequests:
            return "timeOff/timeOffRequests"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createPTO:
            return .post
        case .getRequests:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createPTO(
            let type,
            let isFullDay,
            let startDate,
            let endDate,
            let description
        ):
            return [
                "type": type,
                "isFullDay": isFullDay,
                "startDate": startDate.toString(),
                "endDate": endDate.toString(),
                "description": description
            ]

        case .getRequests:
            return nil
        }
    }
}
