//
//  CalendarItem.swift
//  Chronos
//
//  Created by Samar Assi on 20/04/2024.
//

import Foundation

protocol CalendarItem: ObservableObject {
    var selectedDate: Date? { get set }

    func setSelectedDate(date: Date)
    func getDay(_ weekDay: Int) -> String
}
