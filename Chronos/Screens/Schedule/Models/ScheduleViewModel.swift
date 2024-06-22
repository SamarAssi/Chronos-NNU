//
//  ScheduleViewModel.swift
//  Chronos
//
//  Created by Bassam Hillo on 22/06/2024.
//

import SwiftUI

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

    func getData() async {
        await MainActor.run {
            self.isLoading = true
        }

        do {
            let date = Int(selectedDate.timeIntervalSince1970)
            let response = try await ScheduleClient.getShifts(date: date)
            let shifts = response.shifts.sorted(by: {
                $0.startTime ?? 0 < $1.startTime ?? 0
            }).compactMap { shift in

                let initials = getInitials(from: shift.employeeName)
                let startTime = getTimeAndDate(from: shift.startTime)
                let endTime = getTimeAndDate(from: shift.endTime)

                let backgroundColor: Color
                if let color = employeeColor[shift.employeeID ?? ""] {
                    backgroundColor = color
                } else {
                    let color = getRandomColor()
                    employeeColor[shift.employeeID ?? ""] = color
                    backgroundColor = color
                }

                return ShiftRowUIModel(
                    initials: initials,
                    title: shift.jobDescription ?? "",
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

    func getInitials(from name: String?) -> String {
        guard let name = name else {
            return "--"
        }
        let nameComponents = name.split(separator: " ")
        let initials = nameComponents.compactMap { $0.first }
        return initials.map { String($0) }.joined()
    }

    func getRandomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)

        return Color(red: red, green: green, blue: blue)
    }
}

struct ShiftRowUIModel: Identifiable {
    let id = UUID()
    let initials: String
    let title: String
    let startTime: String
    let endTime: String
    let backgroundColor: Color
}
