//
//  CalendarItemView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct CalendarItemView: View {
    @Binding var selectedDate: Date?
    
    var date: Date
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(date.day)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text(getDay(date.weekday))
                .font(.system(size: 14))
        }
        .foregroundStyle(
            selectedDate == date ? Color.white :
            Color.black
        )
        .frame(width: 70, height: 70)
        .background(cardBackground())
        .onTapGesture {
            selectedDate = date
        }
        .onAppear {
            if selectedDate == nil && Date.isSameDay(date, as: Date()) {
                selectedDate = date
            }
        }
    }
}

extension CalendarItemView {
    enum WeekDay: String {
        case saturday = "Sat"
        case sunday = "Sun"
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed"
        case thursday = "Thu"
        case friday = "Fri"
    }
    
    private func cardBackground() -> some View {
        HStack {
            if selectedDate == date {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
                    .fill(Color.gray.opacity(0.3))
            }
        }
    }
    
    private func getDay(_ weekDay: Int) -> String {
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

#Preview {
    CalendarItemView(selectedDate: .constant(nil), date: Date())
}
