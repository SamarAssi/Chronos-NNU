//
//  ContentView.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: Router
    
    var body: some View {
        switch router.currentRoute {
        case .login:
            LoginView()
        case .home:
            HomeView()
        case .registration:
            RegistrationView()
        case .passwordRecovery:
            PasswordRecoveryView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Router())
}
