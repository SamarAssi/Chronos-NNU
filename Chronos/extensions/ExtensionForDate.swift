//
//  ExtensionForDate.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import Foundation

extension Date {

    static func generateDates(
        from startDate: Date,
        to endDate: Date
    ) -> [Date] {
        var dates = [Date]()
        var currentDate = startDate

        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }

    static func isSameDay(_ date1: Date, as date2: Date) -> Bool {
        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    func toString(format: String = "yyyy-MM-dd'T'HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
