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
        
        if navigationRouter.isLoggedIn {
            HomeView()
        } else {
            NavigationStack(path: $navigationRouter.path) {
                LoginView()
                    .navigationDestination(for: NavigationRouter.AuthScreens.self) { value in
                        switch value {
                        case .login:
                            LoginView()
                        case .registration:
                            RegistrationView()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationRouter())
}
