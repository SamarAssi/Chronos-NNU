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
            let date = Int(selectedDate.timeIntervalSince1970)
            let response = try await ScheduleClient.getShifts(date: date)
            acronymManager.resetColors()
            let shifts = response.shifts.sorted(by: {
                $0.startTime ?? 0 < $1.startTime ?? 0
            }).compactMap { shift in
                

                let name = shift.employeeName
                let id = shift.employeeID
                let initials: String
                let backgroundColor: Color
                (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: name, id: id ?? "")
                
                let startTime = getTimeAndDate(from: shift.startTime)
                let endTime = getTimeAndDate(from: shift.endTime)

                let jobDescription = shift.jobDescription?.trimmingCharacters(in: .whitespacesAndNewlines)
                let titleString: String = (jobDescription?.isEmpty == false ? jobDescription : name) ?? "--"

                return ShiftRowUIModel(
                    id: shift.id ?? "",
                    initials: initials,
                    title: titleString,
                    startTime: startTime,
                    endTime: endTime,
                    backgroundColor: backgroundColor
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

    func getTimeAndDate(from time: Int?) -> String {
        guard let time else {
            return "No Time"
        }

        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a 'on' MMMM dd"
        return formatter.string(from: date)
    }
}

struct ShiftRowUIModel: Identifiable {
    let id: String
    let initials: String
    let title: String
    let startTime: String
    let endTime: String
    let backgroundColor: Color
}
 // open github
