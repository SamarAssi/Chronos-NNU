//
//  RadioButtonModel.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import Foundation
import SwiftUI

struct RadioButtonModel: Identifiable {
    let id = UUID().uuidString
    let tag: Position
    let label: LocalizedStringKey
    let details: LocalizedStringKey
}

extension RadioButtonModel {
    static var data: [RadioButtonModel] {
        [
            RadioButtonModel(
                tag: .manager,
                label: LocalizedStringKey("Manager"),
                details: LocalizedStringKey("Manage your team effortlessly")
            ),
            RadioButtonModel(
                tag: .employee,
                label: LocalizedStringKey("Employee"),
                details: LocalizedStringKey("Join your team tody")
            )
        ]
    }
}

enum Position: Hashable {
    case manager
    case employee
}
