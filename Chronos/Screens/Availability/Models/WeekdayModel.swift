//
//  WeekdayModel.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/05/2024.
//

import SwiftUI

class WeekdayModel: ObservableObject {

    enum Weekdays: String, CaseIterable {
        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
    }

    @Published var weekdays: [Weekday] = []
    @Published var isLoading = true
    @Published var isSubmitting = false

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
                let availabilities = try await AvailabilityClient.getAvailability()
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    weekdays = Weekdays.allCases.enumerated().compactMap { index, weekday in
                        return self.getUIModel(
                            day: availabilities.value(weekday: weekday),
                            dayName: weekday.rawValue,
                            index: index
                        )
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

        let startTime = Date(timeIntervalSince1970: TimeInterval(day.start ?? 0))
        let endTime = Date(timeIntervalSince1970: TimeInterval(day.end ?? 0))
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
            isPendingApproval: true
        )

        isSubmitting = true

        Task {

            defer {
                DispatchQueue.main.async { [weak self] in
                    self?.isSubmitting = false
                }
            }

            do {
                let updatedAvailabilities = try await AvailabilityClient.updateAvailability(
                    availability: availabilities
                )
            } catch {
            }
        }
    }
}

extension Date {
    static func startOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    }
}
