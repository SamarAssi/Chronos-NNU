//
//  EmployeeListModel.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation

@Observable
class EmployeeListModel: ObservableObject {
    
    var employeesResponse: EmployeesResponse?
    var employeeDeletionResponse: EmployeeDeletionResponse?
    var employeeJobsUpdateResponse: EmployeeJobsUpdateResponse?
    var jobsResponse: JobsResponse?
    var employeeDetailsResponse: LoginResponse?
    var jobs: [Job] = []
    
    var isLoading = false
    var isLoadingJobs = false
    
    @MainActor
    func getEmployeesList() {
        showLoading()
        
        Task {
            do {
                employeesResponse = try await EmployeesClient.getEmployees()
                hideLoading()
            } catch let error {
                print(error)
                hideLoading()
            }
        }
    }
    
    @MainActor
    func deleteEmployee(username: String) {
        Task {
            do {
                employeeDeletionResponse = try await EmployeesClient.deleteEmployee(
                    username: username
                )
            } catch let error {
                print(error)
            }
        }
    }
    
    @MainActor
    func updateEmployeeJob(
        employeeId: String,
        jobs: [Job]
    ) {
        isLoadingJobs = true
        Task {
            do {
                let ids = jobs.compactMap { $0.id }
                employeeJobsUpdateResponse = try await EmployeesClient.updateEmployeeJobs(
                    employeeId: employeeId,
                    jobs: ids
                )
                //getEmployeeDetails(employeeId: employeeId)
                isLoadingJobs = false
            } catch let error {
                print(error)
                isLoading = false
            }
        }
    }
    
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
    func getEmployeeDetails(employeeId: String) {
        Task {
            do {
                employeeDetailsResponse = try await EmployeesClient.getEmployeeDetails(
                    employeeId: employeeId
                )
            } catch let error {
                print(error)
            }
        }
    }

    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
}
