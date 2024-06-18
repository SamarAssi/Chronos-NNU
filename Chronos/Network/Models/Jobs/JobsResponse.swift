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
    let name: String
    var label: String {
        return name
    }
}

protocol LabelRepresentable {
    var label: String { get }
}
