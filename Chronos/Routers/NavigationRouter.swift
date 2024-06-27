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
        case onboarding
    }

    @Published var isLoggedIn = UserDefaultManager.accessToken != nil
    @Published var path: [AuthScreens] = []

    func navigateTo(_ route: AuthScreens) {
        if route == .login {
            path.removeAll()
        } else {
            path.append(route)
        }
    }
}
