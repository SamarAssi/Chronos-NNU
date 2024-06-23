//
//  RegistrationView.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import SwiftUI
import SimpleToast

struct RegistrationView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject private var registrationModel = RegistrationModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var isPhoneNumberInvalid = false
    @State private var isSamePassword = false

    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )

    var isDisabledRegisterButton: Bool {
        if areEmptyFields() {
            return true
        } else if !PasswordValidationManager.shared.isPasswordValid() {
            return true
        } else {
            return false
        }
    }
    
    var registerButtonBackgroundColor: Color {
        isDisabledRegisterButton ?
        Color.theme.opacity(0.5) :
        Color.theme
    }
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            titleView
            textFieldListView
            registerButtonView
            
            if fetchEmployeeType() == -1 {
                FooterButton(
                    title: LocalizedStringKey("Already have an account?"),
                    buttonText: LocalizedStringKey("Login"),
                    action: {
                        navigationRouter.navigateTo(.login)
                    }
                )
                .padding(.bottom)
            }
        }
        .fontDesign(.rounded)
        .simpleToast(
            isPresented: $isPhoneNumberInvalid,
            options: toastOptions
        ) {
            invalidPhoneNumberToast
        }
        .simpleToast(
            isPresented: $isSamePassword,
            options: toastOptions
        ) {
            passwordMismatchToast
        }
        .simpleToast(
            isPresented: $registrationModel.isUsernameInvalid,
            options: toastOptions
        ) {
            invalidUsernameToast
        }
    }
}

extension RegistrationView {

    var constraintsView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Password must meet the following requirements:"))
                .padding(.bottom, 4)

            ForEach(PasswordValidationManager.shared.constraints) { constraint in
                Text(constraint.text)
                    .foregroundStyle(
                        constraint.passwordConstraint ?
                        Color.theme :
                        Color.secondary
                    )
            }
        }
        .font(.subheadline)
        .padding(.top, 5)
        .padding(.horizontal, 15)
    }

    var titleView: some View {
        Text(LocalizedStringKey("Register"))
            .foregroundStyle(Color.theme)
            .font(.system(size: 40, weight: .bold))
            .padding(.horizontal, 30)
    }

    var textFieldListView: some View {
        List(registrationModel.textFieldModels) { textFieldModel in
            TextFieldView(textFieldModel: textFieldModel)
                .listRowSeparator(.hidden)
                .padding(.horizontal, 10)
                .onChange(of: registrationModel.textFieldModels[4].text) {
                    PasswordValidationManager.shared.validatePassword(
                        password: registrationModel.textFieldModels[4].text
                    )
                }

            if let lastTextField = registrationModel.textFieldModels.last {
                if lastTextField === textFieldModel {
                    constraintsView
                        .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }

    var registerButtonView: some View {
        MainButton(
            isLoading: $registrationModel.isLoading,
            isEnable: .constant(true),
            buttonText: LocalizedStringKey("Register"),
            backgroundColor: registerButtonBackgroundColor,
            action: {
                isPhoneNumberInvalid = !isValidPhoneNumber(
                    registrationModel.textFieldModels[3].text
                )
                isSamePassword = !checkIsSamePassword()
                if !isPhoneNumberInvalid && checkIsSamePassword() {
                    register()
                }
            }
        )
        .padding(.horizontal, 30)
        .disabled(isDisabledRegisterButton)
        .frame(height: 70)
    }

    var invalidPhoneNumberToast: some View {
        ToastView(
            type: .error,
            message: LocalizedStringKey("Invalid phone number")
        )
        .padding(.horizontal, 30)
    }

    var passwordMismatchToast: some View {
        ToastView(
            type: .error,
            message: LocalizedStringKey("Password mismatch")
        )
        .padding(.horizontal, 30)
    }

    var invalidUsernameToast: some View {
        ToastView(
            type: .error,
            message: LocalizedStringKey("Username is invalid")
        )
        .padding(.horizontal, 30)
    }
}

extension RegistrationView {

    private func areEmptyFields() -> Bool {
        for index in registrationModel.textFieldModels.indices {
            if registrationModel.textFieldModels[index].text.isEmpty && index != 3 {
                return true
            }
        }
        return false
    }

    private func checkIsSamePassword() -> Bool {
        return registrationModel.textFieldModels[4].text == registrationModel.textFieldModels[5].text
    }

    private func register() {
        registrationModel.handleRegistrationResponse { success in
            if success {
                navigationRouter.navigateTo(.onboarding)
            }
        }
    }

    private func isValidPhoneNumber(_ value: String) -> Bool {
        guard !value.isEmpty else { return true }
        let phoneRegex = #"^\d{10}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: value)
    }

    private func fetchEmployeeType() -> Int {
        if let employeeType = KeychainManager.shared.fetch(
            key: KeychainKeys.employeeType.rawValue
        ) {
            return Int(employeeType) ?? -1
        }

        return -1
    }
}

#Preview {
    RegistrationView()
        .environmentObject(NavigationRouter())
}
