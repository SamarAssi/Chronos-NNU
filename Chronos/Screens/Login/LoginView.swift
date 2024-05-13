//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI
import NVActivityIndicatorView

struct LoginView: View {
    @State private var isLoading = false
    @State private var isCorrectInputs = true
    @State private var response: LoginResponse?
    @State private var email = ""
    @State private var password = ""

    @EnvironmentObject var navigationRouter: NavigationRouter

    var isLoginButtonDisabled: Bool {
        isEmptyFields() ?
        true :
        false
    }

    var loginButtonColor: Color {
        isEmptyFields() ?
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
                text: $email,
                label: LocalizedStringKey("Email"),
                placeholder: LocalizedStringKey("Type your email"),
                isSecure: false,
                isOptionl: false
            )
            .padding(.bottom, 8)

            TextFieldView(
                text: $password,
                label: LocalizedStringKey("Password"),
                placeholder: LocalizedStringKey("Type your password"),
                isSecure: true,
                isOptionl: false
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
            if !isCorrectInputs {
                Text(LocalizedStringKey("Incorrect email or password"))
                    .font(.subheadline)
                    .foregroundStyle(Color.red)
            }

            Spacer()

            Button {
                // TODO: forget password button action
            } label: {
                Text(LocalizedStringKey("Forgot Password?"))
                    .foregroundStyle(Color.black.opacity(0.6))
            }
        }
        .font(.subheadline)
    }

    var loginButtonView: some View {
        VStack(alignment: .center) {
            if isLoading {
                ActivityIndicatorView(type: .ballRotateChase, color: .theme)
                    .padding(.top, 70)
                    .padding(.horizontal, UIScreen.main.bounds.width / 2)
            } else {
                MainButton(
                    buttonText: LocalizedStringKey("Login"),
                    backgroundColor: loginButtonColor,
                    action: {
                        login()
                    }
                )
                .padding(.top, 50)
                .disabled(isLoginButtonDisabled)
            }
        }
    }
}

extension LoginView {
    private func isEmptyFields() -> Bool {
        return email.isEmpty || password.isEmpty
    }

    private func login() {
        handleLoginResponse { success in
            if response?.employeeDetails.employeeType != -1 {
                navigationRouter.isLoggedIn = success
            } else {
                navigationRouter.navigateTo(.onboarding)
            }
        }
    }

    private func handleLoginResponse(completion: @escaping (Bool) -> Void) {
        isLoading = true

        Task {
            do {
                response = try await performLoginRequest()
                isCorrectInputs = true
                isLoading = false
                saveAccessToken()
                completion(true)
            } catch let error {
                print(error)
                isCorrectInputs = false
                isLoading = false
                completion(false)
            }
        }
    }

    private func performLoginRequest() async throws -> LoginResponse {
        return try await AuthenticationClient.login(email: email, password: password)
    }

    private func saveAccessToken() {
        if let response = response {
            KeychainManager.shared.save(
                response.accessToken,
                key: KeychainKeys.accessToken.rawValue
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
}
