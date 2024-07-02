//
//  TimeOffRequests.swift
//  Chronos
//
//  Created by Samar Assi on 27/06/2024.
//

import Foundation

// MARK: - TimeOffRequests
struct TimeOffRequests: Codable, Hashable {
    let timeOffRequests: [TimeOffRequest]?
}

// MARK: - TimeOffRequest
struct TimeOffRequest: Codable, Hashable {
    let id, username, startDate, endDate, employeeId: String?
    let type: String?
    let status: Int?
    let isFullDay: Bool?
    let comment, description: String?
}
