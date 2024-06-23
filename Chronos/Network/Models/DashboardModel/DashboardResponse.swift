//
//  DashboardResponse.swift
//  Chronos
//
//  Created by Samar Assi on 11/05/2024.
//

import Foundation

struct DashboardResponse: Codable, Hashable {
    let shiftsTotalTime: String
    let activities: [CheckInOutTable]
    let shouldShowOnboarding: Bool
}

struct CheckInOutTable: Codable, Hashable {
    let checkInTime: Int
    let checkOutTime: Int?
    let employeeName: String
}
