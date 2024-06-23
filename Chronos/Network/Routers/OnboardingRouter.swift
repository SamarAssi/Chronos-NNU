//
//  OnboardingRouter.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import Foundation
import Alamofire

enum OnboardingRouter: BaseRouter {
    case getIgnoreCheckInOutLocationValue
    case updateCompanyRules(
        companyName: String,
        about: String,
        latitude: Double,
        longitude: Double,
        allowedRadius: Double,
        ignoreCheckInLocation: Bool
    )
    
    var path: String {
        switch self {
        case .getIgnoreCheckInOutLocationValue:
            return "onboarding/myCompany"
        case .updateCompanyRules:
            return "onboarding/updateCompanyRules"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getIgnoreCheckInOutLocationValue:
            return .get
        case .updateCompanyRules:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getIgnoreCheckInOutLocationValue:
            return nil
        case .updateCompanyRules(
            let companyName,
            let about,
            let latitude,
            let longitude,
            let allowedRadius,
            let ignoreCheckInLocation
        ):
            return [
                "companyName": companyName,
                "about": about,
                "latitude": latitude,
                "longitude": longitude,
                "allowedRadius": allowedRadius,
                "ignoreCheckInLocation": ignoreCheckInLocation
            ]
        }
    }
}
