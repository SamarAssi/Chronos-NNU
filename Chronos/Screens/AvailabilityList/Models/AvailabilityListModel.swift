//
//  AvailabilityListModel.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Foundation

class AvailabilityListModel: ObservableObject {
    @Published var response: AvailabilityRequestsListResponse?
    @Published var isLoading = false
    
    @MainActor
    func handleAvailabilityRequests() {
        showLoading()
        
        Task {
            do {
                response = try await performAvailabilityRequest()
                hideLoading()
            } catch let error {
                print(error)
                showLoading()
            }
        }
    }
    
    private func performAvailabilityRequest() async throws -> AvailabilityRequestsListResponse {
        return try await AuthenticationClient.availabilityRequestsList()
    }
    
    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
}
