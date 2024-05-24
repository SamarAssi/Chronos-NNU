//
//  PasswordConstraintsModel.swift
//  Chronos
//
//  Created by Samar Assi on 24/05/2024.
//

import Foundation

struct PasswordConstraintsModel: Identifiable {
    let id = UUID().uuidString
    var containsUppercase = false
    var containsLowercase = false
    var containsNumber = false
    var containsSpecialChar = false
    var hasMinLength = false
}

