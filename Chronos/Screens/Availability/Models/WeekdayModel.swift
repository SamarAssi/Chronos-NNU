//
//  WeekdayModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import Foundation
import SwiftUI

struct Weekday: Codable {
    let monday, tuesday, wednesday, thursday: Day
    let friday, saturday, sunday: Day

    struct Day: Codable {
        let start, end: Int
        let isAvailableAllDay, isNotAvailable: Bool
    }
}

struct WeekdayModel: Identifiable, Equatable {
    let id = UUID().uuidString
    let dayName: String
    let prefix: Int
    let order: Int
    var toggleIsOn: Bool
    var startTime: Date
    var endTime: Date
}

extension WeekdayModel {
    static var weekdays: [WeekdayModel] {
        [
            WeekdayModel(
                dayName: Weekdays.sunday.rawValue,
                prefix: 2,
                order: 1,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            ),
            WeekdayModel(
                dayName: Weekdays.monday.rawValue,
                prefix: 1,
                order: 2,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            ),
            WeekdayModel(
                dayName: Weekdays.tuesday.rawValue,
                prefix: 2,
                order: 3,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            ),
            WeekdayModel(
                dayName: Weekdays.wednesday.rawValue,
                prefix: 1,
                order: 4,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            ),
            WeekdayModel(
                dayName: Weekdays.thursday.rawValue,
                prefix: 2,
                order: 5,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            ),
            WeekdayModel(
                dayName: Weekdays.friday.rawValue,
                prefix: 1,
                order: 6,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            ),
            WeekdayModel(
                dayName: Weekdays.saturday.rawValue,
                prefix: 2,
                order: 7,
                toggleIsOn: false,
                startTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date(),
                endTime: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
            )
        ]
    }
}

enum Weekdays: String {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
