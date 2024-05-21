//
//  WeekdayModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

@Observable
class Weekday: Identifiable, ObservableObject {

    let id = UUID().uuidString
    let dayName: String

    var startTime: Date
    var endTime: Date

    let prefix: Int
    let order: Int

    var isAvailableAllDay: Bool
    var isAvailable: Bool

    var dayTitle: String {
        return dayName.prefix(3).capitalized
    }

    init(
        dayName: String,
        startTime: Date,
        endTime: Date,
        prefix: Int,
        order: Int,
        isAvailable: Bool,
        isAvailableAllDay: Bool
    ) {
        self.dayName = dayName
        self.startTime = startTime
        self.endTime = endTime
        self.prefix = prefix
        self.order = order
        self.isAvailableAllDay = isAvailableAllDay
        self.isAvailable = isAvailable
    }
}
