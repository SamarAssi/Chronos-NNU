//
//  Availability.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Foundation

// MARK: - Availabilities
struct Availabilities: Hashable, Codable {
    let monday, tuesday, wednesday, thursday: Day?
    let friday, saturday, sunday: Day?
    let isPendingApproval: Bool?

    func value(weekday: WeekdayModel.Weekdays) -> Day? {
        switch weekday {
        case .monday:
            return monday
        case .tuesday:
            return tuesday
        case .wednesday:
            return wednesday
        case .thursday:
            return thursday
        case .friday:
            return friday
        case .saturday:
            return saturday
        case .sunday:
            return sunday
        }
    }
}

// MARK: - Day
struct Day: Hashable, Codable {
    let start, end: Double?
    let isAvailableAllDay, isNotAvailable: Bool?
}
