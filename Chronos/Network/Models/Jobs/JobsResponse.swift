//
//  JobsResponse.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import Foundation

struct JobsResponse: Hashable, Codable {
    let jobs: [Job]
}

struct Job: Hashable, Codable, Identifiable, LabelRepresentable {
    let id: String?
    var name: String
    var sundaySettings = WeekdaysSettings(minimumNumberOfEmployees: 1)
    var mondaySettings = WeekdaysSettings(minimumNumberOfEmployees: 1)
    var tuesdaySettings  = WeekdaysSettings(minimumNumberOfEmployees: 1)
    var wednesdaySettings = WeekdaysSettings(minimumNumberOfEmployees: 1)
    var thursdaySettings = WeekdaysSettings(minimumNumberOfEmployees: 1)
    var fridaySettings = WeekdaysSettings(minimumNumberOfEmployees: 1)
    var saturdaySettings = WeekdaysSettings(minimumNumberOfEmployees: 1)
    

    var label: String {
        return name
    }
}

struct WeekdaysSettings: Hashable, Codable {
    var minimumNumberOfEmployees: Int
}

protocol LabelRepresentable {
    var label: String { get }
}
