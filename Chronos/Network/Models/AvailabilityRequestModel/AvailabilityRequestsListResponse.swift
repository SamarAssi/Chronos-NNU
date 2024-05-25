//
//  AvailabilityRequestsListResponse.swift
//  Chronos
//
//  Created by Samar Assi on 25/05/2024.
//

import Foundation

struct AvailabilityRequestsListResponse: Hashable, Codable {
    var requests: [AvailabilityRequestsListDetails]
    
    struct AvailabilityRequestsListDetails: Hashable, Codable {
        var requestId: String
        var employeeName: String
        var date: Double
    }
}
