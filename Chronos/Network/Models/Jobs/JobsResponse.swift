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

struct Job: Hashable, Codable {
    let id: String
    let name: String
}
