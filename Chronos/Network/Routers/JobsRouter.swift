//
//  JobsRouter.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import Foundation
import Alamofire

enum JobsRouter: BaseRouter {
    
    case getJobs
    case updateJobs(name: String)
    
    var path: String {
        switch self {
        case .getJobs:
            return "manager/getCompanyJobs"
        case .updateJobs:
            return "manager/updateCompanyJobs"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getJobs:
            return .get
        case .updateJobs:
            return .put
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getJobs:
            return nil
        case .updateJobs(let name):
            return ["name": name]
        }
    }
}
