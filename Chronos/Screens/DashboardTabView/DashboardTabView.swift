//
//  DashboardTabView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct DashboardTabView: View {
    @State private var isShowTabView = true
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Image(systemName: "house") }

            EmployeeListView()
                .tabItem { Image(systemName: "list.clipboard") }

            Text("hello3")
                .tabItem { Image(systemName: "person.2") }

            Group {
                if fetchEmployeeType() == 0 {
                    AvailabilityView()
                } else {
                    AvailabilityListView()
                }
            }
            .tabItem { Image(systemName: "figure.open.water.swim") }

            ProfileView(isShowTabView: $isShowTabView)
                .tabItem { Image(systemName: "person") }
                .toolbar(
                    isShowTabView ?
                    .visible :
                    .hidden,
                    for: .tabBar
                )
        }
        .tint(Color.theme)
    }
}

extension DashboardTabView {

    private func fetchEmployeeType() -> Int {
        if let employeeType = KeychainManager.shared.fetch(
            key: KeychainKeys.employeeType.rawValue
        ) {
            return Int(employeeType) ?? -1
        }

        return -1
    }
}

#Preview {
    DashboardTabView()
}
