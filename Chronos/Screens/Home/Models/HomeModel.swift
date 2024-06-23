//
//  HomeModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import Foundation
import MapKit

class HomeModel: ObservableObject {

    @Published var dashboardResponse: DashboardResponse?
    @Published var employeesResponse: EmployeesResponse?
    @Published var checkInOutResponse: CheckInOutResponse?
    @Published var employees: [Employee] = []
    @Published var isLoading = true

    @MainActor
    func handleDashboardResponse(
        selectedDate: Date,
        employeeId: String
    ) {
        Task {
            do {
                showLoading()
                dashboardResponse = try await performDashboardRequest(
                    selectedDate: selectedDate,
                    employeeId: employeeId
                )
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }
    
    @MainActor
    func getEmployeesList() {        
        Task {
            do {
                employeesResponse = try await EmployeesClient.getEmployees()
                if let employeesResponse = employeesResponse {
                    employees = employeesResponse.employees
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    @MainActor
    func handleCheckInOutResponse(
        location: CLLocation,
        selectedDate: Date,
        completion: @escaping (Bool) -> Void
    ) {
        Task {
            do {
                let currentLatitude = location.coordinate.latitude
                let currentLongitude = location.coordinate.longitude
                
                checkInOutResponse = try await performCheckInOutRequest(
                    currentLatitude: currentLatitude,
                    currentLongitude: currentLongitude
                )
                
                handleDashboardResponse(
                    selectedDate: selectedDate,
                    employeeId: ""
                )
                completion(true)
            } catch let error {
                print(error)
                completion(false)
            }
        }
    }
    
    private func performCheckInOutRequest(
        currentLatitude: Double,
        currentLongitude: Double
    ) async throws -> CheckInOutResponse {
        return try await DashboardClient.updateCheckInOut(
            currentLatitude: currentLatitude,
            currentLongitude: currentLongitude
        )
    }

    private func performDashboardRequest(
        selectedDate: Date,
        employeeId: String
    ) async throws -> DashboardResponse {
        return try await DashboardClient.dashboard(
            date: Int(selectedDate.timeIntervalSince1970),
            employeeId: employeeId
        )
    }

    private func showLoading() {
        isLoading = true
    }

    private func hideLoading() {
        isLoading = false
    }
}
