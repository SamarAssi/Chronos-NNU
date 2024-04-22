//
//  CalendarItemView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct CalendarItemView<CalendarItemProvider: CalendarItem>: View {
    @ObservedObject var calendarItemProvider: CalendarItemProvider
    var date: Date

    var itemColor: Color {
        calendarItemProvider.selectedDate == date ?
        Color.white :
        Color.primary
    }

    var body: some View {
        VStack(spacing: 5) {
            Text("\(date.day)")
                .font(.title3)
                .fontWeight(.bold)

            Text(calendarItemProvider.getDay(date.weekday))
                .font(.system(size: 14))
        }
        .foregroundStyle(itemColor)
        .frame(width: 80, height: 80)
        .background(adjustCalendarItemBackground(date: date))
        .onTapGesture {
            calendarItemProvider.selectedDate = date
        }
        .onAppear {
            calendarItemProvider.setSelectedDate(date: date)
        }
    }

    func adjustCalendarItemBackground(date: Date) -> some View {
        HStack {
            if calendarItemProvider.selectedDate == date {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .fill(Color.gray.opacity(0.3))
            }
        }
    }
}

#Preview {
    CalendarItemView(calendarItemProvider: ViewModel(), date: Date())
}
