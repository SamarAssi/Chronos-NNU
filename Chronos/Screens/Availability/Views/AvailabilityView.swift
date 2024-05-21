//
//  AvailabilityView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct AvailabilityView: View {
    @StateObject private var weekdayModel = WeekdayModel()

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            titleView
            WeekdaysView(weekdayModel: weekdayModel)
            schedulingView
            sendRequestButtonView
        }
        .fontDesign(.rounded)
    }
}

extension AvailabilityView {

    var titleView: some View {
        Text(LocalizedStringKey("Availability"))
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
    }

    var schedulingView: some View {
        Group {
            if weekdayModel.selectedIndices.isEmpty {
                Text(LocalizedStringKey("You're unavailable for all days"))
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .foregroundStyle(Color.gray)
            } else {
                List(
                    weekdayModel.selectedIndices,
                    id: \.self
                ) { index in
                    schedule(index: index)
                        .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
            }
        }
    }

    var sendRequestButtonView: some View {
        MainButton(
            isLoading: .constant(false),
            buttonText: LocalizedStringKey("Send Request"),
            backgroundColor: Color.theme,
            action: {
               // TODO: implement send request action
            }
        )
        .padding()
    }

    private func datePickerView(index: Int) -> some View {
        HStack(spacing: 10) {
            DatePicker(
                "Start Time",
                selection: $weekdayModel.weekdays[index].startTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            Image(systemName: "arrow.right")
                .fontWeight(.bold)
                .foregroundStyle(Color.theme)
            DatePicker(
                "End Time",
                selection:  $weekdayModel.weekdays[index].endTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
        }
    }

    private func schedule(index: Int) -> some View {
        HStack {
            Text(
                weekdayModel.weekdays[index].dayName
                    .prefix(3)
                    .capitalized
            )
            .frame(width: 40)

            Divider()
            datePickerView(index: index)
            Divider()

            Toggle(
                isOn: $weekdayModel.weekdays[index].isAvailableAllDay
            ) {
                Text("")
            }
            .labelsHidden()
            .tint(Color.theme)
        }
    }
}

#Preview {
    AvailabilityView()
}
