//
//  RegistrationView.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import SwiftUI
import SimpleToast

struct RegistrationView: View {
    @State private var isPhoneNumberInvalid = false
    @State private var isSamePassword = false

    @StateObject var registrationModel = RegistrationModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )

    var isDisabledRegisterButton: Bool {
        areEmptyFields() ?
        true :
        false
    }

    var registerButtonBackgroundColor: Color {
        areEmptyFields() ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        VStack {
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                titleView
                textFieldListView
            }
            registerButtonView

            FooterButton(
                title: LocalizedStringKey("Already have an account?"),
                buttonText: LocalizedStringKey("Login"),
                action: {
                    navigationRouter.navigateTo(.login)
                }
            )
            .padding(.bottom)
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
    var titleView: some View {
        Text(LocalizedStringKey("Register"))
            .foregroundStyle(Color.theme)
            .font(.system(size: 40, weight: .bold))
            .padding(.vertical, 20)
            .padding(.horizontal, 30)
    }

    var textFieldListView: some View {
        List(registrationModel.textFieldModels) { textFieldModel in
            TextFieldView(textFieldModel: textFieldModel)
                .listRowSeparator(.hidden)
                .scrollIndicators(.hidden)
                .padding(.horizontal, 10)
        }
        .listStyle(PlainListStyle())
    }

    var registerButtonView: some View {
        MainButton(
            isLoading: $registrationModel.isLoading,
            buttonText: LocalizedStringKey("Register"),
            backgroundColor: registerButtonBackgroundColor,
            action: {
                isPhoneNumberInvalid = !isValidPhoneNumber(registrationModel.textFieldModels[3].text)
                isSamePassword = !checkIsSamePassword()
                if !isPhoneNumberInvalid && checkIsSamePassword() {
                    register()
                }
            }
        )
        .padding(.horizontal, 30)
        // .disabled(isDisabledRegisterButton)
        .frame(height: 90)
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
}

#Preview {
    RegistrationView()
        .environmentObject(NavigationRouter())
}
