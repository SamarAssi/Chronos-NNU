//
//  HomeModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import Foundation

class HomeModel: ObservableObject {

    @Published var dashboardResponse: DashboardResponse?
    @Published var isLoading = true

    @MainActor
    func handleDashboardResponse(
        selectedDate: Date
    ) {
        Task {
            do {
                showLoading()
                dashboardResponse = try await performDashboardRequest(selectedDate: selectedDate)
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }

    private func performDashboardRequest(
        selectedDate: Date
    ) async throws -> DashboardResponse {
        return try await DashboardClient.dashboard(
            date: Int(selectedDate.timeIntervalSince1970)
        )
    }

    private func showLoading() {
        isLoading = true
    }

    private func hideLoading() {
        isLoading = false
    }
}
