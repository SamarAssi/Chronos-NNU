//
//  ManagerModel.swift
//  Chronos
//
//  Created by Samar Assi on 18/05/2024.
//

import Foundation

class ManagerModel: ObservableObject {

    @Published var isLoading = false
    @Published var description = ""
    @Published var managerResponse: ManagerOnboardingResponse?
    @Published private (set) var textFieldModels = TextFieldModel.managerData

    @MainActor
    func handleManagerOnboardingResponse(
        completion: @escaping (Bool) -> Void
    ) {
        showLoading()

        Task {
            do {
                managerResponse = try await performManagerOnboardingRequest()
                hideLoading()
                saveCompanyInvitationId()
                completion(true)
            } catch let error {
                print(error)
                hideLoading()
                completion(false)
            }
        }
    }

    private func performManagerOnboardingRequest() async throws -> ManagerOnboardingResponse {
        return try await AuthenticationClient.onboardingManager(
            name: textFieldModels.text,
            description: description
        )
    }

    private func saveCompanyInvitationId() {
        if let response = managerResponse {
            UserDefaultManager.companyInvitationId = response.companyInvitationId
        }
    }

    private func hideLoading() {
        isLoading = false
    }

    private func showLoading() {
        isLoading = true
    }
}
