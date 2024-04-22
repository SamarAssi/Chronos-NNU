//
//  RegistrationViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/04/2024.
//

import Foundation
import SwiftUI

final class RegistrationViewModel: ObservableObject {
    @Published var showPassword = false
    @Published var textFieldList: [TextFieldModel] = [
        TextFieldModel(
            text: "",
            label: LocalizedStringKey("First Name"),
            placeholder: "Enter First Name",
            isSecure: false
        ),
        TextFieldModel(
            text: "",
            label: "Last Name",
            placeholder: "Enter Last Name",
            isSecure: false
        ),
        TextFieldModel(
            text: "",
            label: "Email",
            placeholder: "Enter Email Address",
            isSecure: false
        ),
        TextFieldModel(
            text: "",
            label: "Password",
            placeholder: "Enter Password",
            isSecure: true
        ),
        TextFieldModel(
            text: "",
            label: "Confirm Password",
            placeholder: "Confirm Password",
            isSecure: true
        )
    ]
}

struct TextFieldModel: Identifiable {
    let id = UUID().uuidString
    var text: String
    let label: LocalizedStringKey
    let placeholder: LocalizedStringKey
    let isSecure: Bool
}
