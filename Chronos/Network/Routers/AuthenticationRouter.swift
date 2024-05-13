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
