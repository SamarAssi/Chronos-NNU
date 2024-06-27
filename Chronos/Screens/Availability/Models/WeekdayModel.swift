//
//  WeekdayModel.swift
//  Chronos
//
//  Created by Samar Assi on 19/05/2024.
//

import SwiftUI

@MainActor
class WeekdayModel: ObservableObject {

    enum Weekdays: String, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }

    @Published var weekdays: [Weekday] = []

    @Published var isLoading = true
    @Published var isSubmitting = false
    @Published var isSentRequest = false
    @Published var isFailedRequest = false

    @Published var updatedAvailabilities: Availabilities?
    @Published var availabilities: Availabilities?
    @Published var comment = ""

    var selectedIndices: [Int] {
        weekdays
            .enumerated()
            .filter({ $0.element.isAvailable == true })
            .map { $0.offset }
    }

    func getData() {
        isLoading = true

        Task {
            do {
                availabilities = try await AvailabilityClient.getAvailability()
                comment = availabilities?.comment ?? ""
                await MainActor.run { [weak self] in
                    guard let self = self else { return }

                    if let availabilities = availabilities {
                        weekdays = Weekdays.allCases.enumerated().compactMap { index, weekday in
                            return self.getUIModel(
                                day: availabilities.value(weekday: weekday),
                                dayName: weekday.rawValue,
                                index: index
                            )
                        }
                    }
                    isLoading = false
                }
            } catch {
                await MainActor.run { [weak self] in
                    print(error)
                    self?.isLoading = false
                }
            }
        }
    }

    func getUIModel(
        day: Day?,
        dayName: String,
        index: Int
    ) -> Weekday? {
        guard let day else { return nil }

        let startTime = day.start?.date ?? Date()
        let endTime = day.end?.date ?? Date()
        return Weekday(
            dayName: dayName,
            startTime: startTime,
            endTime: endTime,
            prefix: (index % 2 == 0) ? 2 : 1,
            isAvailable: day.isNotAvailable == false,
            isAvailableAllDay: day.isAvailableAllDay ?? false
        )
    }

    func submitData() {

        let availabilities = Availabilities(
            monday: weekdays[1].day,
            tuesday: weekdays[2].day,
            wednesday: weekdays[3].day,
            thursday: weekdays[4].day,
            friday: weekdays[5].day,
            saturday: weekdays[6].day,
            sunday: weekdays[0].day,
            isPendingApproval: true,
            comment: comment
        )

        isSubmitting = true

        Task {

            defer {
                DispatchQueue.main.async { [weak self] in
                    self?.isSubmitting = false
                }
            }

            do {
                updatedAvailabilities = try await AvailabilityClient.updateAvailability(
                    availability: availabilities
                )
                isSentRequest = true
                isFailedRequest = false
            } catch let error {
                print(error)
                isSentRequest = false
                isFailedRequest = true
            }
        }
    }
}
