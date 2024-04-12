//
//  ViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import Foundation

final class ViewModel: ObservableObject {
    @Published var userList: [UserModel] = []
    
    
    func getUsers() {
        Task {
            do {
                let users = try await AuthenticationClient.login()
            } catch {
                print(error)
            }
        }
    }
}
