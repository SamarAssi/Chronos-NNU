//
//  JobsListModel.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import Foundation

class JobsListModel: ObservableObject {

    @Published var jobsResponse: JobsResponse?
    @Published var updateJobResponse: UpdateJobResponse?
    @Published var jobs: [Job] = []
    
    @Published var isLoading = false
    
    @MainActor
    func getJobsList() {
        Task {
            do {
                jobsResponse = try await JobsClient.getJobs()
                jobs = jobsResponse?.jobs ?? []
            } catch let error {
                print(error)
            }
        }
    }
    
    @MainActor
    func handleUpdateJobResponse(jobs: [Job]) {
        showLoading()

        Task {
            do {
                updateJobResponse = try await updateJob(jobs: jobs)
                getJobsList()
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }
    
    private func updateJob(jobs: [Job]) async throws -> UpdateJobResponse {
        return try await JobsClient.updateJob(
            jobs: jobs
        )
    }
    
    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
}
