//
//  ConstraintTextModel.swift
//  Chronos
//
//  Created by Samar Assi on 24/05/2024.
//

import Foundation
import SwiftUI

@Observable
class ConstraintTextModel: Identifiable {
    let id = UUID().uuidString
    let text: LocalizedStringKey
    var passwordConstraint: Bool
    
    init(
        text: LocalizedStringKey,
        passwordConstraint: Bool
    ) {
        self.text = text
        self.passwordConstraint = passwordConstraint
    }
}

extension ConstraintTextModel {
    static var data: [ConstraintTextModel] {
        [
            ConstraintTextModel(
                text: LocalizedStringKey("• At least 8 characters"),
                passwordConstraint: false
            ),
            ConstraintTextModel(
                text: LocalizedStringKey("• Contain at least one uppercase letter"),
                passwordConstraint: false
            ),
            ConstraintTextModel(
                text: LocalizedStringKey("• Contain at least one lowercase letter"),
                passwordConstraint: false
            ),
            ConstraintTextModel(
                text: LocalizedStringKey("• Contain at least one number"),
                passwordConstraint: false
            ),
            ConstraintTextModel(
                text: LocalizedStringKey("• Contain at least one special character"),
                passwordConstraint: false
            )
        ]
    }
}
