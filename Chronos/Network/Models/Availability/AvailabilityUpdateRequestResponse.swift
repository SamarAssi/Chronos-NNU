//
//  AvailabilityUpdateRequestResponse.swift
//  Chronos
//
//  Created by Samar Assi on 27/05/2024.
//

import Foundation

struct AvailabilityUpdateRequestResponse: Hashable, Codable {
    var oldAvailability: Availabilities
    var newAvailability: Availabilities
    var conflicts: [AvailabilityConflict]

    struct AvailabilityConflict: Hashable, Codable {
        var day: String
        var start: Double
        var end: Double
    }
}
