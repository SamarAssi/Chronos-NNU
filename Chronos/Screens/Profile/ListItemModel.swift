//
//  ListItemModel.swift
//  Chronos
//
//  Created by Samar Assi on 08/05/2024.
//

import Foundation
import SwiftUI

struct ListItemModel: Identifiable {
    let id = UUID().uuidString
    let name: LocalizedStringKey
    let icon: String
}
