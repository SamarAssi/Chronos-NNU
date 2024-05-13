//
//  RadioButtonModel.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import Foundation
import SwiftUI

struct RadioButtonModel {
    let tag: Position
    let label: LocalizedStringKey
    let details: LocalizedStringKey
}

enum Position: Hashable {
    case manager
    case employee
}
