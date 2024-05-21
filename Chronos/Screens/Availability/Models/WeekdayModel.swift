//
//  WeekdayModel.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/05/2024.
//

import SwiftUI

class WeekdayModel: ObservableObject {

    enum Weekdays: String, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }

    @Published var weekdays: [Weekday]
    var selectedIndices: [Int] {
        weekdays
            .enumerated()
            .filter({ $0.element.isAvailable == true })
            .map { $0.offset }
    }

    init() {
        weekdays = Weekdays.allCases.enumerated().map { index, weekday in
            return Weekday(
                dayName: weekday.rawValue,
                startTime: Date.startOfDay(),
                endTime: Date.startOfDay(),
                prefix: (index % 2 == 0) ? 2 : 1,
                order: index + 1,
                isAvailable: false,
                isAvailableAllDay: false
            )
        }
    }
}

extension Date {
    static func startOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    }
}
