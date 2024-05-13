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
        VStack {
            if navigationRouter.isLoggedIn {
                DashboardTabView()
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
                            case .onboarding:
                                OnboardingView(showFullScreen: .constant(false))
                                    .navigationBarBackButtonHidden(true)
                            }
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
