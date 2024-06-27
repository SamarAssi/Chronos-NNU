//
//  ProfileRowModel.swift
//  Chronos
//
//  Created by Samar Assi on 14/05/2024.
//

import Foundation
import SwiftUI

struct ProfileRowModel: Identifiable {
    let id = UUID()
    let name: LocalizedStringKey
    let icon: String
}

extension ProfileRowModel {
    static var data: [ProfileRowModel] {

        var content = [
            ProfileRowModel(
                name: LocalizedStringKey("My Profile"),
                icon: "person"
            )
        ]

        if UserDefaultManager.employeeType != 1 {
            content.insert(ProfileRowModel (
                name: "Request Time Off",
                icon: "person.badge.clock"
            ), at: 1)
        }

        content.append(
            ProfileRowModel(
                name: LocalizedStringKey("Time Off Requests"),
                icon: "list.bullet"
            )
        )

        return content
    }
}
