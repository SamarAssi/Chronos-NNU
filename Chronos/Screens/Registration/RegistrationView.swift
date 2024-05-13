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
    @State private var isLoading = false
    @State private var isSamePassword = false
    @State private var isUsernameInvalid = false
    @State private var response: LoginResponse?
    @State private var textFields: [TextFieldModel] = []

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
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey("Register"))
                .foregroundStyle(Color.theme)
                .font(.system(size: 40, weight: .bold))
                .padding(.vertical, 20)
                .padding(.horizontal, 30)

            textFieldListView

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
        .onAppear {
            setTextFields()
        }
        .simpleToast(isPresented: $isPhoneNumberInvalid, options: toastOptions) {
            ToastView(
                type: .error,
                message: LocalizedStringKey("Invalid phone number")
            )
            .padding(.horizontal, 30)
        }
        .simpleToast(isPresented: $isSamePassword, options: toastOptions) {
            ToastView(
                type: .error,
                message: LocalizedStringKey("Password mismatch")
            )
            .padding(.horizontal, 30)
        }
        .simpleToast(isPresented: $isUsernameInvalid, options: toastOptions) {
            ToastView(
                type: .error,
                message: LocalizedStringKey("Username is invalid")
            )
            .padding(.horizontal, 30)
        }
    }
}

extension RegistrationView {
    var textFieldListView: some View {
        List(textFields.indices, id: \.self) { index in
            TextFieldView(
                text: Binding<String>(
                    get: { textFields[index].text },
                    set: { newValue in
                        textFields[index].text = newValue
                    }
                ),
                label: textFields[index].label,
                placeholder: textFields[index].placeholder,
                isSecure: textFields[index].isSecure,
                isOptionl: textFields[index].isOptional
            )
            .listRowSeparator(.hidden)
            .scrollIndicators(.hidden)
            .padding(.horizontal, 10)
            .keyboardType(textFields[index].keyboardType)
        }
        .listStyle(PlainListStyle())
    }

    var registerButtonView: some View {
        VStack(alignment: .center) {
            if isLoading {
                ActivityIndicatorView(type: .ballRotateChase, color: .theme)
                    .padding(.top, 45)
                    .padding(.horizontal, UIScreen.main.bounds.width / 2)
            } else {
                MainButton(
                    buttonText: LocalizedStringKey("Register"),
                    backgroundColor: registerButtonBackgroundColor,
                    action: {
                        isPhoneNumberInvalid = !isValidPhoneNumber(textFields[3].text)
                        isSamePassword = !checkIsSamePassword()
                        if !isPhoneNumberInvalid && checkIsSamePassword() {
                            register()
                        }
                    }
                )
                .padding(.horizontal, 30)
                .disabled(isDisabledRegisterButton)
            }
        }
        .frame(height: 90)
    }
}

extension RegistrationView {
    private func areEmptyFields() -> Bool {
        for index in textFields.indices {
            if textFields[index].text.isEmpty && index != 3 {
                return true
            }
        }
        return false
    }

    private func checkIsSamePassword() -> Bool {
        return textFields[4].text == textFields[5].text
    }

    private func register() {
        handleRegistrationResponse { success in
            if success {
                navigationRouter.navigateTo(.onboarding)
            }
        }
    }

    private func handleRegistrationResponse(completion: @escaping (Bool) -> Void) {
        isLoading = true

        Task {
            do {
                response = try await performLoginRequest()
                saveAccessToken()
                isLoading = false
                isUsernameInvalid = false
                completion(true)
            } catch let error {
                print(error)
                isLoading = false
                isUsernameInvalid = true
                completion(false)
            }
        }
    }

    private func performLoginRequest() async throws -> LoginResponse {
        return try await AuthenticationClient.register(textFields: textFields)
    }

    private func saveAccessToken() {
        if let response = response {
            KeychainManager.shared.save(
                response.accessToken,
                key: KeychainKeys.accessToken.rawValue
            )
        }
    }

    private func isValidPhoneNumber(_ value: String) -> Bool {
        guard !value.isEmpty else { return true }
        let phoneRegex = #"^\d{10}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: value)
    }

    private func setTextFields() {
        textFields = [
            TextFieldModel(
                text: "",
                label: LocalizedStringKey("First Name"),
                placeholder: "Enter first name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Last Name",
                placeholder: "Enter last name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Username",
                placeholder: "Enter username",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Phone Number",
                placeholder: "Enter your phone number",
                isSecure: false,
                keyboardType: .phonePad,
                isDisabled: false,
                isOptional: true
            ),
            TextFieldModel(
                text: "",
                label: "Password",
                placeholder: "Enter password",
                isSecure: true,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Confirm Password",
                placeholder: "Confirm password",
                isSecure: true,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            )
        ]
    }
}

#Preview {
    RegistrationView()
        .environmentObject(NavigationRouter())
}
