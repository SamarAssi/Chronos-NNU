//
//  ScheduleClient.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import Foundation

class ScheduleClient: BaseClient {

    static func createShift(
        role: String,
        startTime: Int,
        endTime: Int,
        employeeId: String,
        jobDescription: String
    ) async throws -> String {
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
}
