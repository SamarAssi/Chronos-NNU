//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct LoginView: View {

    @StateObject private var loginModel = LoginModel()
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
        VStack(
            spacing: 10
        ) {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.horizontal, 20)

            VStack(
                spacing: 20
            ) {
                ForEach(loginModel.textFieldModels) { textFieldModel in
                    TextFieldView(textFieldModel: textFieldModel)
                }
            }

            loginFeedbackAndRecoveryButtonView

            loginButtonView

            Spacer()

            FooterButton(
                title: "Don't hava an account?",
                buttonText: "Register",
                action: {
                    navigationRouter.navigateTo(.registration)
                }
            )
        }
        .fontDesign(.rounded)
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
//        .background(Color.white)
    }
}

extension LoginView {

    var loginFeedbackAndRecoveryButtonView: some View {
        HStack {
            if !loginModel.isCorrectInputs {
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
        MainButton(
            isLoading: $loginModel.isLoading,
            isEnable: .constant(true),
            buttonText: "Login",
            backgroundColor: loginButtonColor,
            action: {
                login()
            }
        )
        .padding(.top, 50)
        .disabled(isLoginButtonDisabled)
        .frame(height: 90)
    }
}

extension LoginView {

    private func isEmptyFields() -> Bool {
        return loginModel.textFieldModels[0].text.isEmpty || loginModel.textFieldModels[1].text.isEmpty
    }

    private func login() {
        loginModel.handleLoginResponse { success in
            if loginModel.response?.employeeDetails.employeeType != -1 {
                navigationRouter.isLoggedIn = success
                saveEmployeeType()
            } else {
                navigationRouter.navigateTo(.onboarding)
            }
        }
    }

    private func saveEmployeeType() {
        if let response = loginModel.response {
            UserDefaultManager.employeeType = response.employeeDetails.employeeType
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
}
