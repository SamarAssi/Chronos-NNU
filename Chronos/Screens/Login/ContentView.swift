//
//  ContentView.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        switch navigationRouter.currentRoute {
        case .login:
            LoginView()
        case .registration:
            RegistrationView()
        case .home:
            MainScreen()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationRouter())
}
