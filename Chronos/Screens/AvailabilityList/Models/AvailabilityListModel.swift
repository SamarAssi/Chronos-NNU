//
//  AvailabilityListModel.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Alamofire
import SwiftUI

@Observable
class AvailabilityListModel: ObservableObject {

    var availabilityResponse: AvailabilityRequestsListResponse?
    var approvalResponse: AvailabilityApprovalResponse?
    var rejectionResponse: AvailabilityApprovalResponse?
    var availabilityChangesResponse: AvailabilityUpdateRequestResponse?
    
    var availabilityRowUIModel: [AvailabilityRowUIModel] = []
    var comment: String = ""

    var conflict: [AvailabilityConflict] {
        availabilityChangesResponse?.conflicts ?? []
    }
    
    var isApproved = false
    var isRejected = false
    var isLoading = false
    
    @ObservationIgnored private lazy var acronymManager = AcronymManager()

    @MainActor
    func handleAvailabilityRequests() {
        showLoading()

        Task {
            do {
                availabilityResponse = try await performAvailabilityRequest()
                acronymManager.resetColors()
                availabilityRowUIModel = availabilityResponse?.requests.compactMap {
                    let name = $0.employeeName
                    let initials: String
                    let backgroundColor: Color
                    (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: name, id: $0.id)
                    
                    return AvailabilityRowUIModel(
                        initials: initials,
                        name: name,
                        date: Date(timeIntervalSince1970: $0.date / 1000),
                        backgroundColor: backgroundColor
                    )
                } ?? []
                hideLoading()
            } catch let error {
                print(error)
                showLoading()
            }
        }
    }

    @MainActor
    func handleApprovalResponse(
        at index: Int
    ) {
        Task {
            do {
                approvalResponse = try await performAvailabilityApprovalRequest(at: index)
                handleAvailabilityRequests()
                isApproved = true
            } catch let error {
                print(error)
                isApproved = false
            }
        }
    }

    @MainActor
    func handleRejectionResponse(
        at index: Int
    ) {
        Task {
            do {
                rejectionResponse = try await performAvailabilityRejectionRequest(at: index)
                handleAvailabilityRequests()
                isRejected = true
            } catch let error {
                print(error)
                isRejected = false
            }
        }
    }

    @MainActor
    func handleAvailabilityChangesResponse(
        at index: Int
    ) {
        Task {
            do {
                availabilityChangesResponse = try await performAvailabilityChangesRequest(at: index)
            } catch let error {
                print(error)
            }
        }
    }

    private func performAvailabilityRequest() async throws -> AvailabilityRequestsListResponse {
        return try await AvailabilityClient.availabilityRequestsList()
    }

    private func performAvailabilityApprovalRequest(
        at index: Int
    ) async throws -> AvailabilityApprovalResponse {

        if let availabilityResponse = availabilityResponse {
            let response = try await AvailabilityClient.approveAvailabilityRequest(
                id: availabilityResponse.requests[index].id,
                comment: comment
            )

            comment = ""
            return response

        } else {
            throw ErrorDescription.invalidId
        }
    }

    private func performAvailabilityRejectionRequest(
        at index: Int
    ) async throws -> AvailabilityApprovalResponse {

        if let availabilityResponse = availabilityResponse {
            let response = try await AvailabilityClient.rejectAvailabilityRequest(
                id: availabilityResponse.requests[index].id,
                comment: comment
            )

            comment = ""
            return response
        } else {
            throw ErrorDescription.invalidId
        }
    }

    private func performAvailabilityChangesRequest(
        at index: Int
    ) async throws -> AvailabilityUpdateRequestResponse {

        if let availabilityResponse = availabilityResponse {
            return try await AvailabilityClient.getAvailabilityChangeRequest(
                id: availabilityResponse.requests[index].id
            )
        }
        throw ErrorDescription.invalidId
    }

    private func showLoading() {
        isLoading = true
    }

    private func hideLoading() {
        isLoading = false
    }
}

struct AvailabilityRowUIModel: Identifiable {
    let id = UUID()
    let initials: String
    let name: String
    let date: Date
    let backgroundColor: Color
}
