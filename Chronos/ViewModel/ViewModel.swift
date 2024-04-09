//
//  ViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import Foundation
import Alamofire

final class ViewModel: ObservableObject {
    @Published var userList: [UserModel] = []
    
    //let router = NetworkRouter.home
    
    func getUsers(router: NetworkRouter) {
        Alamofire.request(router).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let jsonData = try? JSONSerialization.data(withJSONObject: value),
                   let users = try? JSONDecoder().decode([UserModel].self, from: jsonData) {
                    self.userList = users
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
}
