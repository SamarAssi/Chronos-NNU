//
//  EmployeesRouter.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation
import Alamofire

enum EmployeesRouter: BaseRouter {
    
    case getEmployees
    
    var path: String {
        switch self {
        case .getEmployees:
            return "manager/getEmployees"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getEmployees:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getEmployees:
            return nil
        }
    }
}
