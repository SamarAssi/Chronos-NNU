//
//  HomeModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import Foundation

class HomeModel: ObservableObject {
    @Published var dashboardResponse: DashboardResponse?
    @Published var isLoading = false
    
    @MainActor
    func handleDashboardResponse(selectedDate: Date) async {
        do {
            showLoading()
            dashboardResponse = try await performDashboardRequest(selectedDate: selectedDate)
            hideLoading()
        } catch let error {
            print(error)
        }
    }
    
    func performDashboardRequest(selectedDate: Date) async throws -> DashboardResponse {
        return try await AuthenticationClient.dashboard(
            date: Int(selectedDate.timeIntervalSince1970)
        )
    }
    
    func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
}