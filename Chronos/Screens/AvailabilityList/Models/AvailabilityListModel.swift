//
//  AvailabilityListModel.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Foundation
import Alamofire

@Observable
class AvailabilityListModel: ObservableObject {

    var availabilityResponse: AvailabilityRequestsListResponse?
    var approvalResponse: AvailabilityApprovalResponse?
    var rejectionResponse: AvailabilityApprovalResponse?
    var availabilityChangesResponse: AvailabilityUpdateRequestResponse?

    var comment: String = ""

    var conflict: [AvailabilityConflict] {
        availabilityChangesResponse?.conflicts ?? []
    }

    var isApproved = false
    var isRejected = false
    var isLoading = false

    @MainActor
    func handleAvailabilityRequests() {
        showLoading()

        Task {
            do {
                availabilityResponse = try await performAvailabilityRequest()
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
