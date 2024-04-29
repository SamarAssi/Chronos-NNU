//
//  LoginRequest.swift
//  Chronos
//
//  Created by Samar Assi on 29/04/2024.
//

import Foundation

struct LoginRequest: Hashable, Codable {
    let username: String
    let password: String
}
