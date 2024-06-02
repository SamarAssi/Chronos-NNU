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
    
    @Published var isLoading = false
    
    @MainActor
    func getJobsList() {
        Task {
            do {
                jobsResponse = try await getJobs()
            } catch let error {
                print(error)
            }
        }
    }
    
    @MainActor
    func handleUpdateJobResponse(name: String) {
        showLoading()

        Task {
            do {
                updateJobResponse = try await updateJob(name: name)
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }
    
    private func getJobs() async throws -> JobsResponse {
        return try await JobsClient.getJobs()
    }
    
    private func updateJob(name: String) async throws -> UpdateJobResponse {
        return try await JobsClient.updateJob(
            name: name
        )
    }
    
    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
}
