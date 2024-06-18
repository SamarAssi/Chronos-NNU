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
    case updateJobs(jobs: [Job])
    
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
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getJobs:
            return nil
        case .updateJobs(let jobs):
            let jobsJson = jobs.compactMap { $0.encodeToDictionary() }
            let json = ["jobs": jobsJson]
            return json
        }
    }
}

extension Encodable {
    func encodeToDictionary() -> [String: Any] {
        let encoder = JSONEncoder()
        guard let json = try? encoder.encode(self),
              let dict = try? JSONSerialization.jsonObject(
                with: json,
                options: []) as? [String: Any]
        else {
            return [:]
        }
        return dict
    }
}
