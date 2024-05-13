//
//  FilteredCalendarCollectionView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct FilteredCalendarCollectionView: View {
    @Binding var selectedDate: Date?
    var startDate: Date
    var endDate: Date
    var onUpdateSelectedDate: () -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach(
                        Date.generateDates(from: startDate, to: endDate),
                        id: \.self
                    ) { date in
                        CalendarItemView(
                            date: date
                        )
                        .foregroundStyle(selectedDate == date ? Color.white : Color.primary)
                        .background(adjustCalendarItemBackground(date: date))
                        .onTapGesture {
                            selectedDate = date
                            onUpdateSelectedDate()
                        }
                        .onAppear {
                            if let selectedDate = selectedDate {
                                proxy.scrollTo(selectedDate, anchor: .center)
                            } else {
                                proxy.scrollTo(date, anchor: .center)
                            }
                            setSelectedDate(date: date)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
    }
}

extension FilteredCalendarCollectionView {
    private func adjustCalendarItemBackground(date: Date) -> some View {
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

    private func setSelectedDate(date: Date) {
        if selectedDate == nil && Date.isSameDay(date, as: Date()) {
            selectedDate = date
        }
    }
}

#Preview {
    FilteredCalendarCollectionView(
        selectedDate: .constant(Date()),
        startDate: Date(),
        endDate: Date(),
        onUpdateSelectedDate: {}
    )
}
