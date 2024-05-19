//
//  RegistrationModel.swift
//  Chronos
//
//  Created by Samar Assi on 16/05/2024.
//

import Foundation

class RegistrationModel: ObservableObject {
    @Published var response: LoginResponse?
    @Published var isLoading = false
    @Published var isUsernameInvalid = false
    @Published private (set) var textFieldModels: [TextFieldModel] = TextFieldModel.registrationData

    @MainActor
    func handleRegistrationResponse(
        completion: @escaping (Bool) -> Void
    ) {
        showLoading()

        Task {
            do {
                response = try await performLoginRequest()
                saveAccessToken()
                hideLoading()
                validateUsername()
                completion(true)
            } catch let error {
                print(error)
                hideLoading()
                invalidateUsername()
                completion(false)
            }
        }
    }

    func performLoginRequest() async throws -> LoginResponse {
        return try await AuthenticationClient.register(textFields: textFieldModels)
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

    private func validateUsername() {
        isUsernameInvalid = false
    }

    private func invalidateUsername() {
        isUsernameInvalid = true
    }
}
