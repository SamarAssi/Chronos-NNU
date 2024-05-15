//
//  WeekdayModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import Foundation
import SwiftUI

struct WeekdayModel: Identifiable {
    let id = UUID().uuidString
    let dayName: LocalizedStringKey
}

extension WeekdayModel {
    static var weekdays: [WeekdayModel] {
        [
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.sunday.rawValue)
            ),
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.monday.rawValue)
            ),
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.tuesday.rawValue)
            ),
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.wednesday.rawValue)
            ),
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.thursday.rawValue)
            ),
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.friday.rawValue)
            ),
            WeekdayModel(
                dayName: LocalizedStringKey(Weekdays.saturday.rawValue)
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
