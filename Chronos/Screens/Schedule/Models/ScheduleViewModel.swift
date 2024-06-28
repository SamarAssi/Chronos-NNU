//
//  ScheduleViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import SwiftUI

@MainActor
@Observable
class ScheduleViewModel: ObservableObject {

    var selectedDate: Date = Date() {
        didSet {
            isDatePickerPresented = false
            Task {
                await getData()
            }
        }
    }
    
    var isDatePickerPresented: Bool = false
    var isLoading = false
    var newShifts: [ShiftRowUI] = []
    var employees: [Employee] = []

    private var employeeColor: [String: Color] = [:]
    
    private var colors: [Color] = [
        .red, .orange, .yellow,
        .green, .mint, .teal, .cyan,
        .blue, .indigo, .purple, .pink,
        .brown, .white, .gray, .black
    ]

    
    func handleShiftDeletion(id: String) {
        Task {
            do {
                try await ScheduleClient.deleteShift(id: id)
                await getData()
            } catch let error {
                print(error)
            }
        }
    }
    
    @ObservationIgnored private lazy var acronymManager = AcronymManager()

    func getData() async {
        await MainActor.run {
            self.isLoading = true
        }
        
        do {
            let date = selectedDate.toString()
            let response = try await ScheduleClient.getShifts(date: date)
            acronymManager.resetColors()

            newShifts = response.shifts.compactMap { shift in

                let name = shift.employeeName
                let id = shift.employeeID
                let initials: String
                let backgroundColor: Color
                (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: name, id: id ?? "")
                
//                let startTime = shift.startTime?.timeAndDate() ?? "--"
//                let endTime = shift.endTime?.timeAndDate() ?? "--"

                let titleString: String = name ?? "--"

                return ShiftRowUI(
                    id: shift.id ?? "",
                    employeeID: shift.employeeID ?? "",
                    initials: initials,
                    employeeName: shift.employeeName ?? "",
                    role: shift.role ?? "Developer",
                    title: titleString,
                    startTime: shift.startTime?.date ?? Date(),
                    endTime: shift.endTime?.date ?? Date(),
                    backgroundColor: backgroundColor,
                    isNew: shift.isNew == true
                )
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            print(error)
        }
    }
    
    func getEmployeesList() {
        Task {
            do {
                let employeesResponse = try await EmployeesClient.getEmployees()
                employees = employeesResponse.employees
            } catch let error {
                print(error)
            }
        }
    }
}

struct ShiftRowUIModel: Identifiable {
    let id: String
    let employeeID: String
    let initials: String
    let employeeName: String
    let role: String
    let title: String
    let startTime: String
    let endTime: String
    let backgroundColor: Color
    let isNew: Bool
}
