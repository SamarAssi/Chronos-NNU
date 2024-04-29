//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI
import NVActivityIndicatorView

struct LoginView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    var isLoginButtonDisabled: Bool {
        loginViewModel.isEmptyFields() ?
        true :
        false
    }

    var loginButtonColor: Color {
        loginViewModel.isEmptyFields() ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

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

            loginFeedbackAndRecoveryButtonView
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
    var loginFeedbackAndRecoveryButtonView: some View {
        HStack {
            if !loginViewModel.isCorrectInputs {
                Text(LocalizedStringKey("Incorrect email or password"))
                    .foregroundStyle(Color.red)
            }
            Spacer()
            Button {

            } label: {
                Text(LocalizedStringKey("Forgot Password?"))
                    .foregroundStyle(Color.black.opacity(0.6))
            }
        }
        .font(.subheadline)
    }

    var loginButtonView: some View {
        VStack(alignment: .center) {
            if loginViewModel.isLoading {
                ActivityIndicatorView(type: .circleStrokeSpin, color: .theme)
                    .padding(.top, 70)
                    .padding(.horizontal, UIScreen.main.bounds.width / 2)
            } else {
                MainButton(
                    buttonText: LocalizedStringKey("Login"),
                    backgroundColor: loginButtonColor,
                    action: {
                        loginAction()
                    }
                )
                .padding(.top, 50)
                .disabled(isLoginButtonDisabled)
            }
        }
    }

    private func loginAction() {
        loginViewModel.loginAction { success in
            navigationRouter.isLoggedIn = success
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
}
