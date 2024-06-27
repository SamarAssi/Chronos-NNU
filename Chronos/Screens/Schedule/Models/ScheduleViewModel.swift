//
//  ScheduleViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import SwiftUI

@MainActor
class ScheduleViewModel: ObservableObject {

    @Published var selectedDate: Date = Date() {
        didSet {
            isDatePickerPresented = false
            Task {
                await getData()
            }
        }
    }
    @Published var shifts: [ShiftRowUIModel] = []
    @Published var isDatePickerPresented: Bool = false
    @Published var isLoading = false


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
                    initials: initials,
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
            }
        } catch {
            print(error)
        }
    }
}

struct ShiftRowUIModel: Identifiable {
    let id: String
    let initials: String
    let title: String
    let startTime: String
    let endTime: String
    let backgroundColor: Color
    let isNew: Bool
}
 // open github
