//
//  ScheduleRouter.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import Alamofire

enum ScheduleRouter: BaseRouter {

    case getShifts
    case createShift(
        role: String,
        startTime: Int,
        endTime: Int,
        employeeId: String,
        jobDescription: String
    )

    var path: String {
        switch self {
        case .createShift:
            return "shifts/create"
        case .getShifts:
            return "shifts/getAllShifts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createShift:
            return .post
        case .getShifts:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createShift(
            let role,
            let startTime,
            let endTime,
            let employeeId,
            let jobDescription
        ):
            return [
                "role": role,
                "startTime": startTime,
                "endTime": endTime,
                "employeeId": employeeId,
                "jobDescription": jobDescription
            ]

        case .getShifts:
            return nil
        }
    }
}
