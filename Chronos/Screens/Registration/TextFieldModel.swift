//
//  TextFieldModel.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import Foundation
import SwiftUI

struct TextFieldModel: Identifiable {
    let id = UUID().uuidString
    var text: String
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let isDisabled: Bool
    let isOptional: Bool
}
