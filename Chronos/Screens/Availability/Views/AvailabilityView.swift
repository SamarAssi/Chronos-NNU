//
//  AvailabilityView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct AvailabilityView: View {
    @StateObject private var weekdayModel = WeekdayModel()
    @State private var showDetailsView = false

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
        .fullScreenCover(isPresented: $showDetailsView) {
            AvailabilityChangeDetailsView()
        }
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
                if weekdayModel.selectedIndices.count > 0 {
                    HStack(spacing: 25) {
                        Text(LocalizedStringKey("START TIME"))
                            .padding(.trailing, 6)
                        Text(LocalizedStringKey("END TIME"))
                            .padding(.leading, 6)
                    }
                    .padding(.top, 8)
                    .padding(.trailing)
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .center)
                }
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
                showDetailsView.toggle()
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
            .frame(width: 50) // by me
            Image(systemName: "arrow.right")
                .fontWeight(.bold)
                .foregroundStyle(Color.theme)
                .frame(width: 50) // by me
            DatePicker(
                "End Time",
                selection:  $weekdayModel.weekdays[index].endTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .frame(width: 50) // by me
        }
    }

    private func schedule(index: Int) -> some View {
        HStack {
            Text(weekdayModel.weekdays[index].dayTitle)
                .frame(width: 40, alignment: .leading) // by me

            Divider()
            datePickerView(index: index)
                .frame(width: 220) // by me
            Divider()

            Toggle(
                isOn: $weekdayModel.weekdays[index].isAvailableAllDay
            ) {
                Text("")
            }
            .labelsHidden()
            .tint(Color.theme)
            .onChange(of: weekdayModel.weekdays[index].isAvailableAllDay) {
                handleToggleChange(at: index)
            }
            .frame(maxWidth: .infinity, alignment: .trailing) // by me
        }
    }
    
    private func handleToggleChange(at index: Int) {
        if weekdayModel.weekdays[index].isAvailableAllDay {
            weekdayModel.weekdays[index].startTime = Calendar.current.date(
                bySettingHour: 0,
                minute: 0,
                second: 0,
                of: Date()
            ) ?? Date()
            weekdayModel.weekdays[index].endTime = Calendar.current.date(
                bySettingHour: 11,
                minute: 59,
                second: 0,
                of: Date()
            ) ?? Date()
        } else {
            weekdayModel.weekdays[index].startTime = Calendar.current.date(
                bySettingHour: 0,
                minute: 0,
                second: 0,
                of: Date()
            ) ?? Date()
            weekdayModel.weekdays[index].endTime = Calendar.current.date(
                bySettingHour: 0,
                minute: 0,
                second: 0,
                of: Date()
            ) ?? Date()
        }
    }
}

#Preview {
    AvailabilityView()
}
