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
    
    
    func getUsers() {
        AuthenticationClient.login { users, error in
            if let users {
                self.userList = users
            } else if let error {
                print("Error fetching. \(error)")
            }
        }
    }
}
