//
//  LoginModel.swift
//  Chronos
//
//  Created by Samar Assi on 16/05/2024.
//

import Foundation

class LoginModel: ObservableObject {
    @Published var response: LoginResponse?
    @Published var isLoading = false
    @Published var isCorrectInputs = true
    @Published private (set) var textFieldModels = TextFieldModel.loginData

    @MainActor
    func handleLoginResponse(completion: @escaping (Bool) -> Void) {
        showLoading()

        Task {
            do {
                response = try await performLoginRequest()
                validateInputs()
                hideLoading()
                saveAccessToken()
                completion(true)
            } catch let error {
                print(error)
                invalidateInputs()
                hideLoading()
                completion(false)
            }
        }
    }

    private func performLoginRequest() async throws -> LoginResponse {
        return try await AuthenticationClient.login(
            email: textFieldModels[0].text,
            password: textFieldModels[1].text
        )
    }

    private func saveAccessToken() {
        if let response = response {
            KeychainManager.shared.save(
                response.accessToken,
                key: KeychainKeys.accessToken.rawValue
            )
        }
    }

    private func showLoading() {
        isLoading = true
    }

    private func hideLoading() {
        isLoading = false
    }

    private func validateInputs() {
        isCorrectInputs = true
    }

    private func invalidateInputs() {
        isCorrectInputs = false
    }
}
