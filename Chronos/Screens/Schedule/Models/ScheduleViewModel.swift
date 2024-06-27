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
    var shifts: [ShiftRowUIModel] = []
    var isDatePickerPresented: Bool = false
    var isLoading = false
    var newShifts: [ShiftRowUI] = []
    
    private var employeeColor: [String: Color] = [:]
    
    private var colors: [Color] = [
        .red, .orange, .yellow,
        .green, .mint, .teal, .cyan,
        .blue, .indigo, .purple, .pink,
        .brown, .white, .gray, .black
    ]
    
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
    
    func convertToShiftRowUI() {
        newShifts = shifts.map { shift in
            let startTime = shift.startTime.date ?? Date()
            let endTime = shift.endTime.date ?? Date()
            
            return ShiftRowUI(
                id: shift.id,
                employeeID: shift.employeeID,
                initials: shift.initials,
                employeeName: shift.employeeName,
                role: shift.role,
                title: shift.title,
                startTime: startTime,
                endTime: endTime,
                backgroundColor: shift.backgroundColor
            )
        }
    }

    
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

            let shifts = response.shifts.compactMap { shift in

                let name = shift.employeeName
                let id = shift.employeeID
                let initials: String
                let backgroundColor: Color
                (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: name, id: id ?? "")
                
                let startTime = shift.startTime?.timeAndDate() ?? "--"
                let endTime = shift.endTime?.timeAndDate() ?? "--"

                let titleString: String = name ?? "--"

                return ShiftRowUIModel(
                    id: shift.id ?? "",
                    employeeID: shift.employeeID ?? "",
                    initials: initials,
                    employeeName: shift.employeeName ?? "",
                    role: shift.role ?? "Developer",
                    title: titleString,
                    startTime: startTime,
                    endTime: endTime,
                    backgroundColor: backgroundColor,
                    isNew: shift.isNew == true
                )
            }
            
            await MainActor.run {
                self.shifts = shifts
                self.isLoading = false
                convertToShiftRowUI()
            }
        } catch {
            print(error)
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
