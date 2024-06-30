//
//  DashboardRouter.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Alamofire
import Foundation

enum DashboardRouter: BaseRouter {

    case checkInOut(currentLatitude: Double, currentLongitude: Double, date: String)
    case dashboard(date: String, employeeId: String? = nil)

    var path: String {
        switch self {
        case .checkInOut:
            return "updateCheckInOut"
        case .dashboard:
            return "dashboard/getDashboard"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .checkInOut:
            return .post
        case .dashboard:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .checkInOut(let currentLatitude, let currentLongitude, let date):
            return [
                "currentLatitude": currentLatitude,
                "currentLongitude": currentLongitude,
                "date": date
            ]
        case .dashboard(let date, let employeeId):
            return [
                "date": date,
                "employeeId": employeeId ?? ""
            ]
        }
    }
}
