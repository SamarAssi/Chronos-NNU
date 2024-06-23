//
//  ProfileRowModel.swift
//  Chronos
//
//  Created by Samar Assi on 14/05/2024.
//

import Foundation
import SwiftUI

struct ProfileRowModel: Identifiable {
    let id = UUID().uuidString
    let name: LocalizedStringKey
    let icon: String
}

extension ProfileRowModel {
    static var data: [ProfileRowModel] {
        [
            ProfileRowModel(
                name: LocalizedStringKey("My Profile"),
                icon: "person"
            ),
            ProfileRowModel(
                name: LocalizedStringKey("Settings"),
                icon: "gearshape"
            ),
            ProfileRowModel(
                name: LocalizedStringKey("Teams & Conditions"),
                icon: "list.bullet.rectangle"
            )
        ]
    }
}
