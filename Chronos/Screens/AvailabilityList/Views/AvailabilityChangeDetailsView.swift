//
//  AvailabilityChangeDetailsView.swift
//  Chronos
//
//  Created by Samar Assi on 23/05/2024.
//

import SwiftUI

struct AvailabilityChangeDetailsView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject private var weekdayModel = WeekdayModel()
    @ObservedObject var availabilityListModel: AvailabilityListModel

    @State private var buttons: [AvailabilityButtonModel] = AvailabilityButtonModel.data

    var date: Date
    var index: Int

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter.string(from: date)
    }

    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                Divider()
                newAvailabilityView
                middleDivider
                oldAvailabilityView
                Divider()
                requestDateView
                buttonsView
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButtonView
                }

                ToolbarItem(placement: .topBarLeading) {
                    titleView
                }
            }
            .fontDesign(.rounded)
        }
        .onAppear {
            availabilityListModel.handleAvailabilityChangesResponse(
                at: index
            )
            weekdayModel.getData()
        }
        .onDisappear {
            availabilityListModel.handleAvailabilityRequests()
        }
    }
}

extension AvailabilityChangeDetailsView {

    var titleView: some View {
        Text(LocalizedStringKey("Availability Change Details"))
            .font(.title3)
            .fontWeight(.bold)
            .padding(.leading)
    }

    var newAvailabilityView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            ForEach(
                weekdayModel.selectedIndices,
                id: \.self
            ) { index in

                if let availabilityChangeResponse = availabilityListModel.availabilityChangesResponse {

                    availabilityTime(
                        availabilityChangeResponse.newAvailability,
                        forDay: weekdayModel.weekdays[index].dayTitle,
                        isNew: true
                    )
                    .listRowSeparator(.hidden)
                }

            }
        }
        .padding(.horizontal, 30)
        .padding(.top)
    }

    var oldAvailabilityView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Current Availability"))
                .font(.system(size: 16))
                .foregroundStyle(Color.gray)

            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                ForEach(
                    weekdayModel.selectedIndices,
                    id: \.self
                ) { index in

                    if let availabilityChangeResponse = availabilityListModel.availabilityChangesResponse {

                        availabilityTime(
                            availabilityChangeResponse.oldAvailability,
                            forDay: weekdayModel.weekdays[index].dayTitle,
                            isNew: false
                        )
                        .listRowSeparator(.hidden)
                    }

                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom)
    }

    var requestDateView: some View {
        Text(
            LocalizedStringKey("Request submitted on \(formattedDate)")
        )
        .frame(maxWidth: .infinity, alignment: .center)
        .font(.system(size: 15, weight: .bold))
        .padding(.vertical, 8)
        .padding(.bottom, 8)
    }

    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }

    var buttonsView: some View {
        HStack {
            ForEach(
                buttons.indices,
                id: \.self
            ) { specificIndex in

                MainButton(
                    isLoading: .constant(false),
                    buttonText: buttons[specificIndex].text,
                    backgroundColor: buttons[specificIndex].backgroundColor,
                    action: {
                        if specificIndex == 0 {
                            availabilityListModel.handleRejectionResponse(at: index)
                        } else if specificIndex == 1 {
                            availabilityListModel.handleApprovalResponse(at: index)
                        }
                        dismiss.callAsFunction()
                    }
                )
                .shadow(radius: 2, x: 0, y: 2)

            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    var middleDivider: some View {
        ZStack {
            Divider()
            Circle()
                .fill(Color.white)
                .frame(width: 60)
                .shadow(radius: 1)
                .overlay(outerCircleOverlayView)
        }
    }

    var outerCircleOverlayView: some View {
        Circle()
            .fill(Color.gray)
            .frame(width: 50)
            .overlay(clockImageView)
    }

    var clockImageView: some View {
        Image(systemName: "clock")
            .font(.system(size: 30))
            .foregroundStyle(Color.white)
    }
}

extension AvailabilityChangeDetailsView {

    private func availabilityTime(
        _ availabilities: Availabilities,
        forDay day: String,
        isNew: Bool
    ) -> some View {
        HStack(
            spacing: 15
        ) {
            Text(day)
                .font(.system(size: 16, weight: .bold))
                .frame(width: 40, alignment: .leading)
                .padding(.vertical, 6)

            Divider()

            availabilityForDay(
                availabilities,
                dayName: day,
                isNew: isNew
            )
        }
    }

    private func availabilityForDay(
        _ availabilities: Availabilities,
        dayName: String,
        isNew: Bool
    ) -> some View {
        Group {
            switch dayName {
            case "Mon":
                setAvailability(
                    forDay: availabilities.monday,
                    isNew: isNew,
                    dayName: dayName
                )

            case "Tue":
                setAvailability(
                    forDay: availabilities.tuesday,
                    isNew: isNew,
                    dayName: dayName
                )

            case "Wed":
                setAvailability(
                    forDay: availabilities.wednesday,
                    isNew: isNew,
                    dayName: dayName
                )

            case "Thu":
                setAvailability(
                    forDay: availabilities.thursday,
                    isNew: isNew,
                    dayName: dayName
                )

            case "Fri":
                setAvailability(
                    forDay: availabilities.friday,
                    isNew: isNew,
                    dayName: dayName
                )

            case "Sat":
                setAvailability(
                    forDay: availabilities.saturday,
                    isNew: isNew,
                    dayName: dayName
                )

            case "Sun":
                setAvailability(
                    forDay: availabilities.sunday,
                    isNew: isNew,
                    dayName: dayName
                )

            default:
                Text("-")
            }
        }
    }

    private func setAvailability(
        forDay day: Day?,
        isNew: Bool,
        dayName: String
    ) -> some View {
        VStack {
            if let day = day,
               let isNotAvailable = day.isNotAvailable,
               let isAvailableAllDay = day.isAvailableAllDay,
               let start = day.start,
               let end = day.end {

                if isNotAvailable {
                    Text(LocalizedStringKey("Not Available"))
                } else if !isAvailableAllDay {
                    Text(
                        formatTime(dateTimeInterval: start)
                        + " - " +
                        formatTime(dateTimeInterval: end)
                    )
                } else if isAvailableAllDay {
                    Text(LocalizedStringKey("All Day"))
                }
            }
        }
        .foregroundColor(
            setChangesColor(
                isNew: isNew,
                forDay: dayName
            )
        )
        .font(.subheadline)
    }

    private func setChangesColor(isNew: Bool, forDay dayName: String) -> Color {
        isNew && hasChanged(
            oldAvailabilities: availabilityListModel.availabilityChangesResponse!.oldAvailability,
            newAvailabilities: availabilityListModel.availabilityChangesResponse!.newAvailability,
            forDay: dayName
        ) ?
        Color.red :
        Color.primary
    }

    private func hasChanged(
        oldAvailabilities: Availabilities,
        newAvailabilities: Availabilities,
        forDay day: String
    ) -> Bool {
        switch day {
        case "Mon":
            return oldAvailabilities.monday != newAvailabilities.monday

        case "Tue":
            return oldAvailabilities.tuesday != newAvailabilities.tuesday

        case "Wed":
            return oldAvailabilities.wednesday != newAvailabilities.wednesday

        case "Thu":
            return oldAvailabilities.thursday != newAvailabilities.thursday

        case "Fri":
            return oldAvailabilities.friday != newAvailabilities.friday

        case "Sat":
            return oldAvailabilities.saturday != newAvailabilities.saturday

        case "Sun":
            return oldAvailabilities.sunday != newAvailabilities.sunday

        default:
            return false
        }
    }

    private func formatTime(dateTimeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: dateTimeInterval / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    AvailabilityChangeDetailsView(
        availabilityListModel: AvailabilityListModel(),
        date: Date(),
        index: 0
    )
}
