//
//  AddEmployeeModel.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation

@Observable
class AddEmployeeModel: ObservableObject {
    var textFields: [TextFieldModel] = TextFieldModel.addEmployeeData
    var registerEmployeeResponse: LoginResponse?
    var jobsResponse: JobsResponse?
    
    var selectedJobs: [Job] = []
    
    var isLoading = false
    var isUsernameInvalid = false
    
    @MainActor
    func handleRegistrationResponse(
        completion: @escaping (Bool) -> Void
    ) {
        showLoading()

        Task {
            do {
                let employeeDetails = LoginResponse.EmployeeDetails(
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
                validateUsername()
                hideLoading()
                completion(true)
            } catch let error {
                print(error)
                invalidateUsername()
                hideLoading()
                completion(false)
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
    
    private func showLoading() {
        isLoading = true
    }
    
    private func hideLoading() {
        isLoading = false
    }
    
    private func validateUsername() {
        isUsernameInvalid = false
    }

    private func invalidateUsername() {
        isUsernameInvalid = true
    }
}
