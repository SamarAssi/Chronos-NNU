//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        VStack(spacing: 10) {

            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.horizontal, 20)

            TextFieldView(
                text: $loginViewModel.email,
                label: LocalizedStringKey("Email"),
                placeholder: LocalizedStringKey("Type your email"),
                isSecure: false
            )
            .padding(.bottom, 8)

            TextFieldView(
                text: $loginViewModel.password,
                label: LocalizedStringKey("Password"),
                placeholder: LocalizedStringKey("Type your password"),
                isSecure: true
            )

            forgotPasswordButtonView
            loginButtonView

            Spacer()

            FooterButton(
                title: LocalizedStringKey("NoAccountQuestion"),
                buttonText: LocalizedStringKey("Register"),
                action: {
                    navigationRouter.navigateTo(.registration)
                }
            )
        }
        .fontDesign(.rounded)
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(Color.white)
    }
}

extension LoginView {
    var forgotPasswordButtonView: some View {
        HStack {
            Spacer()
            Button {

            } label: {
                Text(LocalizedStringKey("Forgot Password?"))
                    .foregroundStyle(Color.black.opacity(0.6))
                    .font(.subheadline)
            }
        }
    }

    var loginButtonView: some View {
        MainButton(
            buttonText: LocalizedStringKey("Login"),
            action: {
                navigationRouter.isLoggedIn = true
            }
        )
        .padding(.top, 50)
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
}
