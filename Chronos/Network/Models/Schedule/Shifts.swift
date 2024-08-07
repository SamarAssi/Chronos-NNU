//
//  Shifts.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import Foundation

// MARK: - Shifts
struct Shifts: Codable {
    let shifts: [Shift]
}

// MARK: - Shift
struct Shift: Codable {
    let id: String?
    let role: String?
    let startTime, endTime: String?
    let jobDescription, employeeID, employeeName: String?
    let isNew: Bool?

    enum CodingKeys: String, CodingKey {
        case role, startTime, endTime, jobDescription, id
        case employeeID = "employeeId"
        case employeeName, isNew
    }
}
