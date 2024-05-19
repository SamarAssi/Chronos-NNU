//
//  WeekdaysView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct WeekdaysView: View {
    @State private var weekdays: [WeekdayModel] = WeekdayModel.weekdays
    @Binding var selectedDays: [WeekdayModel]

    var body: some View {
        HStack(
            spacing: 10
        ) {
            ForEach(weekdays) { weekday in
                Circle()
                    .fill(getBackgroundColor(of: weekday))
                    .overlay(
                        Text(
                            weekday.dayName
                                .prefix(weekday.prefix)
                                .capitalized
                        )
                        .fontWeight(.bold)
                        .foregroundStyle(getForegroundColor(of: weekday))
                    )
                    .onTapGesture {
                        withAnimation {
                            toggleSelection(of: weekday)
                        }
                    }
            }
        }
    }
}

extension WeekdaysView {
    private func toggleSelection(
        of weekday: WeekdayModel
    ) {
        if let index = selectedDays.firstIndex(of: weekday) {
            selectedDays.remove(at: index)
        } else {
            selectedDays.append(weekday)
        }
    }

    private func getForegroundColor(
        of weekday: WeekdayModel
    ) -> Color {
        selectedDays.contains(weekday) ? Color.white : Color.gray
    }

    private func getBackgroundColor(
        of weekday: WeekdayModel
    ) -> Color {
        selectedDays.contains(weekday) ? Color.theme : Color.white
    }
}

#Preview {
    WeekdaysView(selectedDays: .constant([]))
}
