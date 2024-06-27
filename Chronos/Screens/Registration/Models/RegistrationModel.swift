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
                saveFullName()
                saveFirstName()
                saveLastName()
                savePhoneNumber()
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

    private func performLoginRequest() async throws -> LoginResponse {
        return try await AuthenticationClient.register(textFields: textFieldModels)
    }

    private func saveAccessToken() {
        if let response = response {
            UserDefaultManager.accessToken = response.accessToken
        }
    }

    private func saveFullName() {
        if let response = response {
            let name = response.firstName + " " + response.lastName
            UserDefaultManager.fullName = name
        }
    }
    
    private func saveFirstName() {
        if let response = response {
            let firstName = response.firstName
            UserDefaultManager.firstName = firstName
        }
    }
    
    private func saveLastName() {
        if let response = response {
            let lastName = response.lastName
            UserDefaultManager.lastName = lastName
        }
    }
    
    private func savePhoneNumber() {
        if let response = response {
            let phone = response.phone
            UserDefaultManager.phoneNumber = phone
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
