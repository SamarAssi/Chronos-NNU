//
//  MainViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/04/2024.
//

import Foundation
import SwiftUI

// MARK: Published Properties
final class MainViewModel: ObservableObject {
    @Published var activities: [String] = []
    @Published var selectedDate: Date?
    @Published var currentDragOffsetX: CGFloat = 0
    @Published var isReached = false
    @Published var isShow = true
    
    let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    let endDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
}

// MARK: HomeView Methods
extension MainViewModel {
    func scrollBackground() -> some View {
        GeometryReader { proxy in
            let contentHeight = proxy.size.height
            let minY = max(
                min(0, proxy.frame(in: .named("ScrollView")).minY),
                UIScreen.main.bounds.height - contentHeight
            )
            Color.clear
                .onChange(of: minY) { oldVal, newVal in
                    if (self.isShow && newVal < oldVal) || !self.isShow && newVal > oldVal {
                        self.isShow = newVal > oldVal
                    }
                }
        }
    }
}

// MARK: CalendarItemView Methods
extension MainViewModel {
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
    
    func cardBackground(date: Date) -> some View {
        HStack {
            if selectedDate == date {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .fill(Color.gray.opacity(0.3))
            }
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
extension MainViewModel {
    func setColor() -> LinearGradient {
        isReached ?
        LinearGradient(
            colors: [Color.lightTheme, Color.lightTheme.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        ) :
        LinearGradient(
            colors: [Color.theme, Color.theme.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }
    
    func setSwipeLimitation() -> CGFloat {
        return min(
            max(currentDragOffsetX, 0),
            UIScreen.main.bounds.width - 95
        )
    }
    
    func setText() -> String {
        isReached ? "Swipe to Check Out" : "Swipe to Check In"
    }
    
    func handleDragChanged(value: DragGesture.Value) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentDragOffsetX = value.translation.width
        }
    }
    
    func handleDragEnded() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if currentDragOffsetX >= UIScreen.main.bounds.width - 95 {
                isReached.toggle()
            }
            
            currentDragOffsetX = 0
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
