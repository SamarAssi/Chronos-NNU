//
//  Router.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    enum Route {
        case login
        case home
        case registration
        case passwordRecovery
    }
    
    @Published var currentRoute: Route = .login
    
    func navigateTo(_ route: Route) {
        currentRoute = route
    }
}
