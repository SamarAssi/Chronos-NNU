//
//  EmployeeModel.swift
//  Chronos
//
//  Created by Samar Assi on 18/05/2024.
//

import Foundation

class EmployeeModel: ObservableObject {
    @Published var isLoading = false
    @Published var isCorrectId = true
    @Published var employeeResponse: OnboardingEmployeeRespone?
    @Published private (set) var textFieldModels = TextFieldModel.employeeData

    @MainActor
    func handleEmployeeOnboardingResponse(
        completion: @escaping (Bool) -> Void
    ) {
        showLoading()

        Task {
            do {
                employeeResponse = try await performEmployeeOnboardingRequest()
                hideLoading()
                validateId()
                completion(true)
            } catch let error {
                print(error)
                hideLoading()
                invalidateId()
                completion(false)
            }
        }
    }

    private func performEmployeeOnboardingRequest() async throws -> OnboardingEmployeeRespone {
        return try await AuthenticationClient.onboardingEmployee(id: textFieldModels.text)
    }

    private func hideLoading() {
        isLoading = false
    }

    private func showLoading() {
        isLoading = true
    }

    private func validateId() {
        isCorrectId = true
    }

    private func invalidateId() {
        isCorrectId = false
    }
}
