//
//  NavigationRouter.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import Foundation

class NavigationRouter: ObservableObject {

    enum AuthScreens {
        case login
        case registration
    }

    @Published var isLoggedIn = false
    @Published var path: [AuthScreens] = []

    func navigateTo(_ route: AuthScreens) {
        if route == .login {
            path.removeAll()
        } else {
            path.append(route)
        }
    }
}
