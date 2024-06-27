//
//  ScheduleRouter.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import Alamofire

enum ScheduleRouter: BaseRouter {

    case getShifts(date: String)
    case createShift(
        role: String,
        startTime: String,
        endTime: String,
        employeeId: String,
        jobDescription: String
    )
    case deleteShift(id: String)
    case suggestShifts(answers: [Answer])
    case createShifts(shifts: Shifts)

    var path: String {
        switch self {
        case .createShift:
            return "shifts/create"
        case .getShifts:
            return "shifts"
        case .deleteShift(let id):
            return "shifts/delete/\(id)"
        case .suggestShifts:
            return "shifts/suggestion"
        case .createShifts:
            return "shifts/createShiftsFromSuggestions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createShift, .suggestShifts, .createShifts:
            return .post
        case .getShifts:
            return .post
        case .deleteShift:
            return .delete
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

        case .getShifts(let date):
            return [
                "date": date
            ]
        case .deleteShift:
            return nil
        case .suggestShifts(let answers):
            return [
                "answers": answers.compactMap { $0.encodeToDictionary() }
            ]

        case .createShifts(let shifts):
            return shifts.encodeToDictionary()
        }

    }
}
