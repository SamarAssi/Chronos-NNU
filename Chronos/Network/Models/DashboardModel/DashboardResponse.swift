//
//  DashboardResponse.swift
//  Chronos
//
//  Created by Samar Assi on 11/05/2024.
//

import Foundation

struct DashboardResponse: Codable, Hashable {
    let shifts: [Shift]
    let activities: [CheckInOutTable]
    let shouldShowOnboarding: Bool

    struct Shift: Codable, Hashable {
        let shiftName: String
        let startTime: Int
        let endTime: Int
        let jobDescription: String
    }

    struct CheckInOutTable: Codable, Hashable {
        let checkInTime: Int
        let checkOutTime: Int?
    }
}
