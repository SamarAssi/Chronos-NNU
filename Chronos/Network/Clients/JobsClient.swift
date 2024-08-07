//
//  JobsClient.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import Foundation

class JobsClient: BaseClient {

    static func getJobs() async throws -> JobsResponse {
        let router: JobsRouter = .getJobs
        return try await performRequest(router: router)
    }
    
    static func updateJob(
        jobs: [Job]
    ) async throws -> UpdateJobResponse {
        let router: JobsRouter = .updateJobs(jobs: jobs)
        return try await performRequest(router: router)
    }
}
