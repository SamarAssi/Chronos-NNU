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
                getEmployeesList()
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
                getEmployeeDetails(employeeId: employeeId)
                getEmployeesList()
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
                if let employeeDetailsResponse = employeeDetailsResponse {
                    self.jobs = employeeDetailsResponse.employeeDetails.jobs
                }
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
    
    
    
    var textFields: [TextFieldModel] = TextFieldModel.addEmployeeData

    var registerEmployeeResponse: LoginResponse?
    
    var selectedJobs: [Job] = []
    
    var isLoadingEmployeeList = false
    var isUsernameInvalid = false
    
    @MainActor
    func handleRegistrationResponse(
        completion: @escaping (Bool) -> Void
    ) {
        showLoadingEmployeeList()

        Task {
            do {
                let employeeDetails = EmployeeDetails(
                    jobs: selectedJobs,
                    employeeType: 0,
                    joinedDate: "",
                    salary: 0,
                    reportsTo: "",
                    companyName: ""
                )
                registerEmployeeResponse = try await EmployeesClient.registerEmployee(
                    textFields: textFields,
                    employeeDetails: employeeDetails
                )
                getEmployeesList()
                validateUsername()
                hideLoadingEmployeeList()
                completion(true)
            } catch let error {
                print(error)
                invalidateUsername()
                hideLoadingEmployeeList()
                completion(false)
            }
        }
    }
    
    private func showLoadingEmployeeList() {
        isLoadingEmployeeList = true
    }
    
    private func hideLoadingEmployeeList() {
        isLoadingEmployeeList = false
    }
    
    private func validateUsername() {
        isUsernameInvalid = false
    }

    private func invalidateUsername() {
        isUsernameInvalid = true
    }
}
