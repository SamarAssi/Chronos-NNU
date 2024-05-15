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

extension TextFieldModel {
    static var registrationData: [TextFieldModel] {
        [
            TextFieldModel(
                text: "",
                label: LocalizedStringKey("First Name"),
                placeholder: "Enter first name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Last Name",
                placeholder: "Enter last name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Username",
                placeholder: "Enter username",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Phone Number",
                placeholder: "Enter your phone number",
                isSecure: false,
                keyboardType: .phonePad,
                isDisabled: false,
                isOptional: true
            ),
            TextFieldModel(
                text: "",
                label: "Password",
                placeholder: "Enter password",
                isSecure: true,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Confirm Password",
                placeholder: "Confirm password",
                isSecure: true,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            )
        ]
    }
    
    static var editingData: [TextFieldModel] {
        [
            TextFieldModel(
                text: "",
                label: LocalizedStringKey("First Name"),
                placeholder: "Enter first name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Last Name",
                placeholder: "Enter last name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Phone Number",
                placeholder: "Enter your phone number",
                isSecure: false,
                keyboardType: .phonePad,
                isDisabled: false,
                isOptional: false
            )
        ]
    }
}
