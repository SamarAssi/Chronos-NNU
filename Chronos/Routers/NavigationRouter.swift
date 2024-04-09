//
//  NavigationRouter.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import Foundation

class NavigationRouter: ObservableObject {
    enum Route {
        case login
        case home
    }
    
    @Published var currentRoute: Route = .login
    
    func navigateTo(_ route: Route) {
        currentRoute = route
    }
}
