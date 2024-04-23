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

    var itemColor: Color {
        selectedDate == date ?
        Color.white :
        Color.primary
    }

    var body: some View {
        VStack(spacing: 5) {
            Text("\(date.day)")
                .font(.title3)
                .fontWeight(.bold)

            Text(getDay(date.weekday))
                .font(.system(size: 14))
        }
        .foregroundStyle(itemColor)
        .frame(width: 80, height: 80)
        .background(adjustCalendarItemBackground(date: date))
        .onAppear {
            setSelectedDate()
        }
    }
}

extension CalendarItemView {
    func adjustCalendarItemBackground(date: Date) -> some View {
        HStack {
            if selectedDate == date {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .fill(Color.gray.opacity(0.3))
            }
        }
    }

    enum WeekDay: String {
        case saturday = "Sat"
        case sunday = "Sun"
        case monday = "Mon"
        case tuesday = "Tue"
        case wednesday = "Wed"
        case thursday = "Thu"
        case friday = "Fri"
    }

    func setSelectedDate() {
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

#Preview {
    CalendarItemView(selectedDate: .constant(nil), date: Date())
}
