//
//  CreateShiftViewModel.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import SwiftUI

class CreateShiftViewModel: ObservableObject {

    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedEmployeeID: String?
    @Published var selectedJobName: String?

    private(set) var employees: [Employee] = []

    @Published var isLoading: Bool = false
    @Published var isSubmitting: Bool = false

    var selectedEmployeeName: String? {
        employees.first { $0.id == selectedEmployeeID }?.username
    }

    var jobs: [Job] {
        employees.first { $0.id == selectedEmployeeID }?.jobs ?? []
    }

    func getData() async {
        await MainActor.run {
            isLoading = true
        }

        do {
            let response = try await EmployeesClient.getEmployees()
            await MainActor.run {
                employees = response.employees
                isLoading = false
            }
        } catch {
            print(error)
        }
    }

    func createShift() {
        isSubmitting = true
        Task {
            do {
                let _ = try await ScheduleClient.createShift(
                    role: selectedJobName ?? "",
                    startTime: Int(startDate.timeIntervalSince1970),
                    endTime: Int(endDate.timeIntervalSince1970),
                    employeeId: selectedEmployeeID ?? "",
                    jobDescription: "Test"
                )
                await MainActor.run {
                    isSubmitting = false
                }
            } catch {
                print(error)
            }
        }
    }
}
