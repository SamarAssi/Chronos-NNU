//
//  AvailabilityView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI
import SimpleToast

struct AvailabilityView: View {

    @StateObject private var weekdayModel = WeekdayModel()

    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            titleView
            WeekdaysView(weekdayModel: weekdayModel)

            if let availabilities = weekdayModel.availabilities,
               let isPendingApproval = availabilities.isPendingApproval,
               isPendingApproval {
                pendingApprovalLabelView
            } else if let updatedAvailabilities = weekdayModel.updatedAvailabilities,
                      let isPendingApproval = updatedAvailabilities.isPendingApproval,
                      isPendingApproval {
                pendingApprovalLabelView
            }

            schedulingView
            sendRequestButtonView
        }
        .progressLoader($weekdayModel.isLoading)
        .fontDesign(.rounded)
        .task {
            weekdayModel.getData()
        }
        .simpleToast(
            isPresented: $weekdayModel.isSentRequest,
            options: toastOptions
        ) {
            ToastView(
                type: .success,
                message: "Your request has been sent"
            )
            .padding(.horizontal)
        }
        .simpleToast(
            isPresented: $weekdayModel.isFailedRequest,
            options: toastOptions
        ) {
            ToastView(
                type: .error,
                message: "New availability is the same as the current availability"
            )
            .padding(.horizontal)
        }
    }
}

extension AvailabilityView {

    var titleView: some View {
        Text(LocalizedStringKey("Availability"))
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
            .padding(.bottom)
    }

    var pendingApprovalLabelView: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title3)

            Text(LocalizedStringKey("Your request is awaiting approval"))
                .fontWeight(.bold)
                .font(.subheadline)
        }
        .foregroundStyle(Color.darkYellow)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .padding(.horizontal, 6)
        .background(Color.darkYellow.opacity(0.1))
    }

    var schedulingView: some View {
        Group {
            if weekdayModel.selectedIndices.isEmpty {
                unavailableLabelView
            } else {
                if weekdayModel.selectedIndices.count > 0 {
                    availabilityTimeLabelsView
                }
                availabilityListView
            }
        }
    }

    var unavailableLabelView: some View {
        Text(LocalizedStringKey("You're unavailable for all days"))
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
            .foregroundStyle(Color.gray)
    }

    var availabilityTimeLabelsView: some View {
        HStack(
            spacing: 25
        ) {
            Text(LocalizedStringKey("START TIME"))
                .padding(.trailing, 20)
            Text(LocalizedStringKey("END TIME"))
                .padding(.trailing, 17)
            Text(LocalizedStringKey("ALL DAY"))
        }
        .padding(.top, 10)
        .padding(.trailing)
        .font(.system(size: 14))
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    var availabilityListView: some View {
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

    var sendRequestButtonView: some View {
        MainButton(
            isLoading: $weekdayModel.isSubmitting,
            buttonText: "Send Request",
            backgroundColor: Color.theme,
            action: {
                weekdayModel.submitData()
            }
        )
        .padding()
    }
}

extension AvailabilityView {

    private func datePickerView(index: Int) -> some View {
        HStack(
            spacing: 10
        ) {
            DatePicker(
                "Start Time",
                selection: $weekdayModel.weekdays[index].startTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .frame(width: 50)

            Image(systemName: "arrow.right")
                .fontWeight(.bold)
                .foregroundStyle(Color.theme)
                .frame(width: 50)

            DatePicker(
                "End Time",
                selection: $weekdayModel.weekdays[index].endTime,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .frame(width: 50)
        }
    }

    private func schedule(index: Int) -> some View {
        HStack {
            Text(weekdayModel.weekdays[index].dayTitle)
                .frame(width: 40, alignment: .leading)

            Divider()

            datePickerView(index: index)
                .frame(width: 220)

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
            .frame(maxWidth: .infinity, alignment: .trailing)
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
