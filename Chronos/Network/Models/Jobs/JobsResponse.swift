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
    var sundaySettings, mondaySettings, tuesdaySettings: WeekdaysSettings
    var wednesdaySettings, thursdaySettings, fridaySettings, saturdaySettings: WeekdaysSettings

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
