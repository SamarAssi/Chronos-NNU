//
//  AvailabilityRequestsListResponse.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Foundation

class AvailabilityRequestsListResponse: Hashable, Codable {

    enum CodingKeys: String, CodingKey {
        case requests
        case id
        case employeeName
        case date
    }

    var requests: [AvailabilityRequestsListDetails]

    init(requests: [AvailabilityRequestsListDetails]) {
        self.requests = requests
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        requests = try container.decode([AvailabilityRequestsListDetails].self, forKey: .requests)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requests, forKey: .requests)
    }

    static func == (
        lhs: AvailabilityRequestsListResponse,
        rhs: AvailabilityRequestsListResponse
    ) -> Bool {
        return lhs.requests == rhs.requests
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(requests)
    }

    class AvailabilityRequestsListDetails: Hashable, Identifiable, Codable {

        var id: String
        var employeeName: String
        var date: String

        init(id: String, employeeName: String, date: String) {
            self.id = id
            self.employeeName = employeeName
            self.date = date
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            employeeName = try container.decode(String.self, forKey: .employeeName)
            date = try container.decode(String.self, forKey: .date)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(employeeName, forKey: .employeeName)
            try container.encode(date, forKey: .date)
        }

        static func == (
            lhs: AvailabilityRequestsListResponse.AvailabilityRequestsListDetails,
            rhs: AvailabilityRequestsListResponse.AvailabilityRequestsListDetails
        ) -> Bool {
            return lhs.id == rhs.id &&
            lhs.employeeName == rhs.employeeName &&
            lhs.date == rhs.date
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(employeeName)
            hasher.combine(date)
        }
    }
}
