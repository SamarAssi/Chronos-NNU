//
//  TimeOffRequests.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import Foundation

// MARK: - TimeOffRequests
struct TimeOffRequests: Codable {
    let timeOffRequests: [TimeOffRequest]?
}

// MARK: - TimeOffRequest
struct TimeOffRequest: Codable {
    let id, username, startDate, endDate: String?
    let type: String?
    let status: Int?
    let isFullDay: Bool?
    let comment: String?
}
