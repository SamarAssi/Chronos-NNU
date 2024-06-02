//
//  EmployeeListModel.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation

class EmployeeListModel: ObservableObject {
    
    @Published var employeesResponse: EmployeesResponse?
    
    @Published var isLoading = false
    
    @MainActor
    func getEmployeesList() {
        showLoading()
        
        Task {
            do {
                employeesResponse = try await getEmployees()
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }
    
    private func getEmployees() async throws -> EmployeesResponse {
        return try await EmployeesClient.getEmployees()
    }
    
    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
}
