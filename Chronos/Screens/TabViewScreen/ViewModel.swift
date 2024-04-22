//
//  ViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 20/04/2024.
//

import Foundation
import SwiftUI

// MARK: Published Properties
final class ViewModel: ObservableObject, Home, CalendarItem, SwipeButton {
    @Published var activities: [String] = []
    @Published var selectedDate: Date?
    @Published var currentDragOffsetX: CGFloat = 0.0
    @Published var isReached = false
    @Published var isShowProfileHeader = true
    @Published var width: CGFloat = 0

    let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    let endDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
}

// MARK: HomeView Methods
extension ViewModel {
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

// MARK: CalendarItemView Methods
extension ViewModel {
    enum WeekDay: String {
        case saturday = "Sat"
        case sunday = "Sun"
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed"
        case thursday = "Thu"
        case friday = "Fri"
    }

    func setSelectedDate(date: Date) {
        if selectedDate == nil && Date.isSameDay(date, as: Date()) {
            selectedDate = date
        }
    }

    func getDay(_ weekDay: Int) -> String {
        switch weekDay {
        case 1:
            return WeekDay.sunday.rawValue
        case 2:
            return WeekDay.monday.rawValue
        case 3:
            return WeekDay.tuesday.rawValue
        case 4:
            return WeekDay.wednesday.rawValue
        case 5:
            return WeekDay.thursday.rawValue
        case 6:
            return WeekDay.friday.rawValue
        case 7:
            return WeekDay.saturday.rawValue
        default:
            return ""
        }
    }
}

// MARK: SwipeToUnLockView Methods
extension ViewModel {
    func setSwipeButtonLimintation() -> CGFloat {
        return min(
            max(currentDragOffsetX, 0),
            UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60
        )
    }

    func getSwipeButtonText() -> String {
        isReached ? "Swipe to Check Out" : "Swipe to Check In"
    }

    func handleDragChanged(value: DragGesture.Value) {
        currentDragOffsetX = value.translation.width
    }

    func handleDragEnded() {
        if currentDragOffsetX >= UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60 {
            isReached.toggle()
        }

        currentDragOffsetX = 0
    }
    
    private func getRemainderOfHalfScreen() -> CGFloat {
        return UIScreen.main.bounds.size.width - width
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
