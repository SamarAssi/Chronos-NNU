//
//  AttendanceCardModel.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import Foundation
import SwiftUI

struct AttendanceCardModel: Identifiable {
    let id = UUID().uuidString
    let cardIcon: String
    let cardTitle: LocalizedStringKey
    let time: Int
    let note: LocalizedStringKey
}
