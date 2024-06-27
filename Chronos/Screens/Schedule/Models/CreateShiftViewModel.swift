//
//  CreateShiftViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import SwiftUI

@MainActor
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
    @Published var createdShift: ShiftRowUI?
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
    
    @ObservationIgnored private lazy var acronymManager = AcronymManager()

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
        let shift = try await ScheduleClient.createShift(
            role: selectedJobName ?? "",
            startTime: Int(startDate.timeIntervalSince1970),
            endTime: Int(endDate.timeIntervalSince1970),
            employeeId: selectedEmployeeID ?? "",
            jobDescription: description
        )
        
        let initials: String
        let backgroundColor: Color
        (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: shift.employeeName ?? "", id: shift.employeeID ?? "")
        
        let startTime = shift.startTime?.timeAndDate(in: TimeZone.current) ?? "--"
        let endTime = shift.endTime?.timeAndDate(in: TimeZone.current) ?? "--"
        
        createdShift = ShiftRowUI(
            id: shift.id ?? "",
            employeeID: shift.employeeID ?? "",
            initials: initials,
            employeeName: shift.employeeName ?? "",
            role: shift.role ?? "",
            title: shift.jobDescription ?? "",
            startTime: parseDate(startTime),
            endTime: parseDate(endTime),
            backgroundColor: backgroundColor
        )

        await MainActor.run {
            isSubmitting = false
        }
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM d"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            print("Failed to parse date string: \(dateString)")
            return Date()
        }
    }
}

