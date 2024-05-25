//
//  AvailabilityResponse.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Foundation

@Observable
class AvailabilityResponse: Codable {
    let monday: Day
    let tuesday: Day
    let wednesday: Day
    let thursday: Day
    let friday: Day
    let saturday: Day
    let sunday: Day
    let isPendingApproval: Bool
    
    init(
        monday: Day = Day(),
        tuesday: Day = Day(),
        wednesday: Day = Day(),
        thursday: Day = Day(),
        friday: Day = Day(),
        saturday: Day = Day(),
        sunday: Day = Day(),
        isPendingApproval: Bool = false
    ) {
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
        self.sunday = sunday
        self.isPendingApproval = isPendingApproval
    }
    
    private enum CodingKeys: String, CodingKey {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday, isPendingApproval
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.monday = try container.decode(Day.self, forKey: .monday)
        self.tuesday = try container.decode(Day.self, forKey: .tuesday)
        self.wednesday = try container.decode(Day.self, forKey: .wednesday)
        self.thursday = try container.decode(Day.self, forKey: .thursday)
        self.friday = try container.decode(Day.self, forKey: .friday)
        self.saturday = try container.decode(Day.self, forKey: .saturday)
        self.sunday = try container.decode(Day.self, forKey: .sunday)
        self.isPendingApproval = try container.decode(Bool.self, forKey: .isPendingApproval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(monday, forKey: .monday)
        try container.encode(tuesday, forKey: .tuesday)
        try container.encode(wednesday, forKey: .wednesday)
        try container.encode(thursday, forKey: .thursday)
        try container.encode(friday, forKey: .friday)
        try container.encode(saturday, forKey: .saturday)
        try container.encode(sunday, forKey: .sunday)
        try container.encode(isPendingApproval, forKey: .isPendingApproval)
    }
}

@Observable
class Day: Codable {
    var start: Double?
    var end: Double?
    
    var isAvailableAllDay: Bool
    var isNotAvailable: Bool
    
    init(
        start: Double? = nil,
        end: Double? = nil,
        isAvailableAllDay: Bool = true,
        isNotAvailable: Bool = false
    ) {
        self.start = start
        self.end = end
        self.isAvailableAllDay = isAvailableAllDay
        self.isNotAvailable = isNotAvailable
    }
    
    private enum CodingKeys: String, CodingKey {
        case start, end, isAvailableAllDay, isNotAvailable
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.start = try container.decodeIfPresent(Double.self, forKey: .start)
        self.end = try container.decodeIfPresent(Double.self, forKey: .end)
        self.isAvailableAllDay = try container.decode(Bool.self, forKey: .isAvailableAllDay)
        self.isNotAvailable = try container.decode(Bool.self, forKey: .isNotAvailable)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(start, forKey: .start)
        try container.encode(end, forKey: .end)
        try container.encode(isAvailableAllDay, forKey: .isAvailableAllDay)
        try container.encode(isNotAvailable, forKey: .isNotAvailable)
    }
}

//@Observable
//class AvailabilityResponse: Codable {
//    
//    enum Weekdays: String, CaseIterable {
//        case sunday, monday, tuesday, wednesday, thursday, friday, saturday
//    }
//    var isPendingApproval: Bool = false
//    var weekdays: [WeekDay]
//    var selectedIndices: [Int] {
//        weekdays
//            .enumerated()
//            .filter({ $0.element.isAvailable == true })
//            .map { $0.offset }
//    }
//
//    init() {
//        weekdays = Weekdays.allCases.enumerated().map { index, weekday in
//            return WeekDay(
//                dayName: weekday.rawValue,
//                startTime: Date.startOfDay(),
//                endTime: Date.startOfDay(),
//                prefix: (index % 2 == 0) ? 2 : 1,
//                order: index + 1,
//                isAvailable: false,
//                isAvailableAllDay: false
//            )
//        }
//    }
//}
//
//@Observable
//class WeekDay: Codable {
//
//    var dayName: String
//
//    var startTime: Date
//    var endTime: Date
//
//    var prefix: Int
//    var order: Int
//
//    var isAvailableAllDay: Bool
//    var isAvailable: Bool
//
//    var dayTitle: String {
//        return dayName.prefix(3).capitalized
//    }
//
//    init(
//        dayName: String,
//        startTime: Date,
//        endTime: Date,
//        prefix: Int,
//        order: Int,
//        isAvailable: Bool,
//        isAvailableAllDay: Bool
//    ) {
//        self.dayName = dayName
//        self.startTime = startTime
//        self.endTime = endTime
//        self.prefix = prefix
//        self.order = order
//        self.isAvailableAllDay = isAvailableAllDay
//        self.isAvailable = isAvailable
//    }
//}

extension Date {
    static func startOfDay() -> Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    }
}
