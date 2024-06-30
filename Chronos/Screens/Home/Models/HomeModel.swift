//
//  HomeModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import Foundation
import MapKit
import SwiftUI

class HomeModel: ObservableObject {
    
    @Published var dashboardResponse: DashboardResponse?
    @Published var employeesResponse: EmployeesResponse?
    @Published var checkInOutResponse: CheckInOutResponse?
    @Published var employees: [Employee] = []
    @Published var isLoading = true
    
    @Published var timeOffRequestRowUIModel: [TimeOffRequestRowUIModel] = []
    
    @ObservationIgnored private lazy var acronymManager = AcronymManager()
    
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
                
                timeOffRequestRowUIModel = dashboardResponse?.offEmployees.compactMap {
                    let username = $0.username
                    let initials: String
                    let backgroundColor: Color
                    (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: username, id: $0.id ?? "")
                    
                    
                    return TimeOffRequestRowUIModel(
                        id: $0.id ?? "",
                        initials: initials,
                        username: username ?? "",
                        startDate: $0.startDate?.date ?? Date(),
                        endDate: $0.endDate?.date ?? Date(),
                        backgroundColor: backgroundColor
                    )
                } ?? []
                
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
        showLoading()
        Task {
            do {
                let currentLatitude = location.coordinate.latitude
                let currentLongitude = location.coordinate.longitude
                
                checkInOutResponse = try await performCheckInOutRequest(
                    currentLatitude: currentLatitude,
                    currentLongitude: currentLongitude,
                    date: Date()
                )
                
                handleDashboardResponse(
                    selectedDate: selectedDate,
                    employeeId: ""
                )
                completion(true)
                handleDashboardResponse(selectedDate: selectedDate, employeeId: "")
            } catch let error {
                handleDashboardResponse(selectedDate: selectedDate, employeeId: "")
                print(error)
                completion(false)
            }
        }
    }
    
    private func performCheckInOutRequest(
        currentLatitude: Double,
        currentLongitude: Double,
        date: Date
    ) async throws -> CheckInOutResponse {
        return try await DashboardClient.updateCheckInOut(
            currentLatitude: currentLatitude,
            currentLongitude: currentLongitude,
            date: date.toString()
        )
    }
    
    private func performDashboardRequest(
        selectedDate: Date,
        employeeId: String
    ) async throws -> DashboardResponse {
        return try await DashboardClient.dashboard(
            date: selectedDate.toString(),
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
