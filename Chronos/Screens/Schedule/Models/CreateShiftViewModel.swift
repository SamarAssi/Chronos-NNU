//
//  CreateShiftViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import SwiftUI

class CreateShiftViewModel: ObservableObject {

    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var selectedJobName: String?
    @Published var selectedEmployeeID: String? {
        didSet {
            let selectedJobs = employees.first { $0.id == selectedEmployeeID }?.jobs ?? []
            selectedJobName = selectedJobs.first?.name
            jobs = selectedJobs
        }
    }

    @Published var description: String = "" {
        didSet {
            isButtonEnabled = !description.isEmpty
        }
    }
    @Published var isLoading: Bool = false
    @Published var isSubmitting: Bool = false
    @Published var isButtonEnabled: Bool = false

    private(set) var employees: [Employee] = []

    var selectedEmployeeName: String? {
        employees.first { $0.id == selectedEmployeeID }?.username
    }

    var jobs: [Job] = []

    var JobTitle: String? {
        guard !jobs.isEmpty else {
            return "No Jobs"
        }

        return selectedJobName
    }

    func getData() async {
        await MainActor.run {
            isLoading = true
        }

        do {
            let response = try await EmployeesClient.getEmployees()
            await MainActor.run {
                employees = response.employees
                selectedEmployeeID = employees.first?.id
                isLoading = false
            }
        } catch {
            print(error)
        }
    }

    func createShift() async throws {
        await MainActor.run {
            isSubmitting = true
        }
        let _ = try await ScheduleClient.createShift(
            role: selectedJobName ?? "",
            startTime: startDate.toString(),
            endTime: startDate.toString(),
            employeeId: selectedEmployeeID ?? "",
            jobDescription: description
        )

        await MainActor.run {
            isSubmitting = false
        }
    }
}

