//
//  Shifts.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import Foundation

// MARK: - Shifts
struct Shifts: Codable {
    let shifts: [Shift]
}

// MARK: - Shift
struct Shift: Codable {
    let role: String?
    let startTime, endTime: Int?
    let jobDescription, employeeID, employeeName: String?

    enum CodingKeys: String, CodingKey {
        case role, startTime, endTime, jobDescription
        case employeeID = "employeeId"
        case employeeName
    }
}
