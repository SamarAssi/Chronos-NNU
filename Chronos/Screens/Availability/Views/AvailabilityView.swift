//
//  AvailabilityView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct AvailabilityView: View {
    @State private var selectedDays: [WeekdayModel] = []
    
    var sortedSelectedDays: [WeekdayModel] {
        selectedDays.sorted { $0.order < $1.order }
    }

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            titleView
                .padding(.horizontal)
            horizontalDividerView
            WeekdaysView(selectedDays: $selectedDays)
                .padding(.horizontal)
            horizontalDividerView
            schedulingView
            sendRequestButtonView
                .padding()
        }
        .fontDesign(.rounded)
    }
}

extension AvailabilityView {
    var titleView: some View {
        Text(LocalizedStringKey("Availability"))
            .font(.title2)
            .fontWeight(.bold)
    }

    var horizontalDividerView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 1)
    }

    var verticalDividerView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(width: 1)
    }

    var schedulingView: some View {
        VStack {
            if selectedDays.isEmpty {
                Spacer()
                Text(LocalizedStringKey("You're unavailable for all days"))
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                List(sortedSelectedDays) { selectedDay in
                    schedule(of: selectedDay)
                        .listRowSeparator(.hidden)
                }
                .padding()
                .listStyle(PlainListStyle())
                .scrollIndicators(.hidden)
               // horizontalDividerView
            }
        }
        .foregroundStyle(Color.gray)
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
    }

    private func datePickerView(for selectedDay: WeekdayModel) -> some View {
        HStack(spacing: 10) {
            DatePicker(
                "",
                selection: Binding(
                    get: { selectedDay.startTime },
                    set: { newValue in
                        if let index = selectedDays.firstIndex(of: selectedDay) {
                            selectedDays[index].startTime = newValue
                        }
                    }
                ),
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            Image(systemName: "arrow.right")
                .fontWeight(.bold)
                .foregroundStyle(Color.theme)
            DatePicker(
                "",
                selection: Binding(
                    get: { selectedDay.endTime },
                    set: { newValue in
                        if let index = selectedDays.firstIndex(of: selectedDay) {
                            selectedDays[index].endTime = newValue
                        }
                    }
                ),
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
        }
    }


    private func schedule(of selectedDay: WeekdayModel) -> some View {
        HStack(
            spacing: 25
        ) {
            Text(
                selectedDay.dayName
                    .prefix(3)
                    .capitalized
            )
            .frame(width: 45, alignment: .leading)
            verticalDividerView
            datePickerView(for: selectedDay)
            verticalDividerView
            Toggle(
                isOn: Binding(
                    get: { selectedDay.toggleIsOn },
                    set: { newValue in
                        if let index = selectedDays.firstIndex(of: selectedDay) {
                            selectedDays[index].toggleIsOn = newValue
                            handleToggleChange(
                                for: selectedDay,
                                isOn: newValue
                            )
                        }
                    }
                )
            ) {
                Text("")
            }
            .labelsHidden()
            .tint(Color.theme)
        }
    }
    
    private func handleToggleChange(
        for day: WeekdayModel,
        isOn: Bool
    ) {
        if isOn {
        }
    }
}

#Preview {
    AvailabilityView()
}
