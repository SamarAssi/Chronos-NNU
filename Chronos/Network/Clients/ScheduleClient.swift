//
//  ScheduleClient.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import Foundation

class ScheduleClient: BaseClient {

    static func createShift(
        role: String,
        startTime: Int,
        endTime: Int,
        employeeId: String,
        jobDescription: String
    ) async throws -> Shift {
        let router: ScheduleRouter = .createShift(
            role: role,
            startTime: startTime,
            endTime: endTime,
            employeeId: employeeId,
            jobDescription: jobDescription
        )
        return try await performRequest(router: router)
    }

    static func getShifts(date: Int) async throws -> Shifts {
        let router: ScheduleRouter = .getShifts(date: date)
        return try await performRequest(router: router)
    }
    
    static func deleteShift(id: String) async throws {
        let router: ScheduleRouter = .deleteShift(id: id)
        try await performVoidRequest(router: router)
    }

    static func suggestShifts(message: String) async throws -> Shifts {
        let router: ScheduleRouter = .suggestShifts(message: message)
        return try await performRequest(router: router)
    }

    static func createShifts(shifts: Shifts) async throws -> UpdateCompanyRulesResponse {
        let router: ScheduleRouter = .createShifts(shifts: shifts)
        return try await performRequest(router: router)
    }
}
