//
//  AuthenticationClient.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import Foundation
import Alamofire

class AuthenticationClient {
    static func login(completion: @escaping ([UserModel]?, Error?) -> Void) {
        let router: NetworkRouter = .home
        Alamofire.request(router).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                   let users = try? JSONDecoder().decode([UserModel].self, from: jsonData) {
                    completion(users, nil)
                } else {
                    completion(
                        nil,
                        NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse data"])
                    )
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
