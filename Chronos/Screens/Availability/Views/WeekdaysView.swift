//
//  WeekdaysView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct WeekdaysView: View {

    @ObservedObject var weekdayModel: WeekdayModel

    var body: some View {
        VStack {
            Divider()
            HStack {
                ForEach(
                    weekdayModel.weekdays.indices,
                    id: \.self
                ) { index in
                    dayButton(index: index)
                }
            }
            .padding(.horizontal)
            Divider()
        }
    }
}

extension WeekdaysView {

    private func dayButton(
        index: Int
    ) -> some View {
        Button {
            weekdayModel.weekdays[index].isAvailable.toggle()
        } label: {
            Circle()
                .fill(getBackgroundColor(index))
                .overlay(
                    Text(
                        weekdayModel.weekdays[index].dayName
                            .prefix(weekdayModel.weekdays[index].prefix)
                            .capitalized
                    )
                    .fontWeight(.bold)
                    .foregroundStyle(getForegroundColor(index))
                )
                .padding(4)
        }
    }

    private func getForegroundColor(
        _ index: Int
    ) -> Color {
        weekdayModel.weekdays[index].isAvailable ?
        Color.white :
        Color.gray
    }

    private func getBackgroundColor(
        _ index: Int
    ) -> Color {
        weekdayModel.weekdays[index].isAvailable ?
        Color.theme :
        Color.clear
    }
}

#Preview {
    WeekdaysView(weekdayModel: WeekdayModel())
}
