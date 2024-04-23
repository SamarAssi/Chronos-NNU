//
//  MainViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 23/04/2024.
//

import Foundation
import SwiftUI

// MARK: Published Properties
final class MainViewModel: ObservableObject {
    @Published var activities: [String] = []
    @Published var isShowProfileHeader = true

    let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    let endDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
}

// MARK: HomeView Methods
extension MainViewModel {
    func calculateVerticalContentOffset(_ proxy: GeometryProxy) -> CGFloat {
        let contentHeight = proxy.size.height
        return max(
            min(0, proxy.frame(in: .named("ScrollView")).minY),
            UIScreen.main.bounds.height - contentHeight
        )
    }

    func adjustShowCalendarState<T: Comparable & Equatable>(
        from oldVal: T,
        to newVal: T
    ) {
        if (isShowProfileHeader && newVal < oldVal) || (!isShowProfileHeader && newVal > oldVal) {
            isShowProfileHeader = newVal > oldVal
        }
    }
}

// MARK: extension for Date
extension Date {
    var day: Int {
        Calendar.current.component(.day, from: self)
    }

    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    static func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
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
}
