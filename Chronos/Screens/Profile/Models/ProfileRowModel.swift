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
            ),
            ProfileRowModel(
                name: LocalizedStringKey("Time Off Requests"),
                icon: "list.bullet"
            )
        ]

        if UserDefaultManager.employeeType != 1 {
            content.append(ProfileRowModel (
                name: "Request Time Off",
                icon: "person.badge.clock"
            ))
        }

        return content
    }
}
