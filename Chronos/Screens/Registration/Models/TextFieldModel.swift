//
//  TextFieldModel.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import Foundation
import SwiftUI

class TextFieldModel: ObservableObject, Identifiable {
    let id = UUID().uuidString
    @Published var text: String
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let isDisabled: Bool
    let isOptional: Bool

    init(
        text: String,
        label: LocalizedStringKey,
        placeholder: LocalizedStringKey,
        isSecure: Bool,
        keyboardType: UIKeyboardType,
        isDisabled: Bool,
        isOptional: Bool
    ) {
        self.text = text
        self.label = label
        self.placeholder = placeholder
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.isDisabled = isDisabled
        self.isOptional = isOptional
    }
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

    static var managerData: TextFieldModel {
        TextFieldModel(
            text: "",
            label: "Company Name:",
            placeholder: "Enter company name",
            isSecure: false,
            keyboardType: .asciiCapable,
            isDisabled: false,
            isOptional: false
        )
    }

    static var employeeData: TextFieldModel {
        TextFieldModel(
            text: "",
            label: "ID:",
            placeholder: "Enter company ID",
            isSecure: false,
            keyboardType: .asciiCapable,
            isDisabled: false,
            isOptional: false
        )
    }

    static var loginData: [TextFieldModel] {
        [
            TextFieldModel(
                text: "",
                label: "Email",
                placeholder: "Type your email",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Password",
                placeholder: "Type your password",
                isSecure: true,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            )
        ]
    }
}
