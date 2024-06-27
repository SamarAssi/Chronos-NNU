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
    case updateTimeOffStatus(
        status: Int,
        timeOffId: String,
        comment: String?
    )
    case deleteRequest(timeOffId: String)

    var path: String {
        switch self {
        case .createPTO:
            return "timeOff/addTimeOffRequest"
        case .getRequests:
            return "timeOff/timeOffRequests"
        case .updateTimeOffStatus:
            return "timeOff/updateTimeOffStatus"
        case .deleteRequest(timeOffId: let timeOffId):
            return "timeOff/removeTimeOffRequest/\(timeOffId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createPTO, .updateTimeOffStatus:
            return .post
        case .getRequests:
            return .get
        case .deleteRequest:
            return .delete
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

        case .getRequests, .deleteRequest:
            return nil
        case .updateTimeOffStatus(
            let status,
            let timeOffId,
            let comment
        ):
            return [
                "status": status,
                "timeOffId": timeOffId,
                "comment": comment ?? ""
            ]
        }
    }
}
