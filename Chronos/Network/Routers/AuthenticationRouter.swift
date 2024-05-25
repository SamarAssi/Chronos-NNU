//
//  AuthenticationRouter.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import Alamofire

enum AuthenticationRouter: BaseRouter {
    case login(username: String, password: String)
    case onboardingManager(name: String, description: String)
    case onboardingEmployee(id: String)
    case registration(firstName: String, lastName: String, username: String, phone: String, password: String)
    case checkInOut
    case dashboard(date: Int)
    case availability
    case requestChange
    case requests
    case approve
    case reject
    case availabilityChanges
    case home

    var path: String {
        switch self {
        case .login:
            return "https://timeshift-420211.ew.r.appspot.com/auth/login"
        case .onboardingManager:
            return "https://timeshift-420211.ew.r.appspot.com/onboarding/createCompany"
        case .onboardingEmployee:
            return "https://timeshift-420211.ew.r.appspot.com/onboarding/addUserToCompany"
        case .registration:
            return "https://timeshift-420211.ew.r.appspot.com/auth/register"
        case .checkInOut:
            return "https://timeshift-420211.ew.r.appspot.com/updateCheckInOut"
        case .dashboard:
            return "https://timeshift-420211.ew.r.appspot.com/dashboard/getDashboard"
        case .availability:
            return "https://timeshift-420211.ew.r.appspot.com/availability"
        case .requestChange:
            return "https://timeshift-420211.ew.r.appspot.com/availability/requestChange"
        case .requests:
            return "https://timeshift-420211.ew.r.appspot.com/availability/requests"
        case .approve:
            return "https://timeshift-420211.ew.r.appspot.com/availability/approve"
        case .reject:
            return "https://timeshift-420211.ew.r.appspot.com/availability/reject"
        case .availabilityChanges:
            return "https://timeshift-420211.ew.r.appspot.com/availability/availabilityChanges"
        case .home:
            return "home"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .onboardingManager:
            return .post
        case .onboardingEmployee:
            return .post
        case .registration:
            return .post
        case .checkInOut:
            return .post
        case .dashboard:
            return .post
        case .availability:
            return .get
        case .requestChange:
            return .post
        case .requests:
            return .get
        case .approve:
            return .post
        case .reject:
            return .post
        case .availabilityChanges:
            return .post
        case .home:
            return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let username, let password):
            return ["username": username, "password": password]
        case .onboardingManager(let name, let description):
            return ["companyName": name, "about": description]
        case .onboardingEmployee(let id):
            return ["invitationId": id]
        case .registration(
            let firstName,
            let lastName,
            let username,
            let phone,
            let password
        ):
            return [
                "firstName": firstName,
                "lastName": lastName,
                "username": username,
                "phone": phone,
                "password": password
            ]
        case .dashboard(let date):
            return ["date": date]
        default:
            return nil
        }
    }
}
