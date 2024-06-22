//
//  DashboardRouter.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Alamofire
import Foundation

enum DashboardRouter: BaseRouter {

    case checkInOut(currentLatitude: Double, currentLongitude: Double)
    case dashboard(date: Int)

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
        case .checkInOut(let currentLatitude, let currentLongitude):
            return ["currentLatitude": currentLatitude, "currentLongitude": currentLongitude]
        case .dashboard(let date):
            return ["date": date]
        }
    }
}
