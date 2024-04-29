//
//  LoginViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/04/2024.
//

import Foundation
import SwiftUI

//@MainActor
final class LoginViewModel: ObservableObject {
    @Published var response: LoginResponse?
    @Published var accessTokens: [AccessTokenEntity] = []
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var isCorrectInputs = true

    func loginAction(completion: @escaping (Bool) -> Void) {
        isLoading = true

        Task {
            await handleAuthentication(completion: completion)
        }
    }

    func handleAuthentication(completion: @escaping (Bool) -> Void) async {
        do {
            let response = try await AuthenticationClient.login(email: email, password: password)
            DispatchQueue.main.async {
                self.response = response
                self.isCorrectInputs = true
                self.addAccessToken()
                self.isLoading = false
                completion(true)
            }
        } catch let error {
            print(error)
            response = nil
            DispatchQueue.main.async {
                self.isCorrectInputs = false
                self.isLoading = false
                completion(false)
            }
        }
    }

    func isEmptyFields() -> Bool {
        return email.isEmpty || password.isEmpty
    }

    private func addAccessToken() {
        guard !isEmptyFields() else { return }
        accessTokens = CoreDataManager.shared.addAccessToken(accessToken: response?.accessToken ?? "") ?? []
    }
}
