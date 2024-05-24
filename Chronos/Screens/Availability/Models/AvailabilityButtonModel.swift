//
//  AvailabilityButtonModel.swift
//  Chronos
//
//  Created by Samar Assi on 23/05/2024.
//

import Foundation
import SwiftUI

struct AvailabilityButtonModel: Identifiable {
    let id = UUID().uuidString
    let text: LocalizedStringKey
    let backgroundColor: Color
}

extension AvailabilityButtonModel {
    static var data: [AvailabilityButtonModel] {
        [
            AvailabilityButtonModel(
                text: "Deny",
                backgroundColor: Color.red
            ),
            AvailabilityButtonModel(
                text: "Approve",
                backgroundColor: Color.theme
            )
        ]
    }
}
