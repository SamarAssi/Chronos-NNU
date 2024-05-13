//
//  DashboardTabView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct DashboardTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Image(systemName: "house") }

            Text("hello2")
                .tabItem { Image(systemName: "list.clipboard") }

            Text("hello3")
                .tabItem { Image(systemName: "person.2") }

            Text("hello5")
                .tabItem { Image(systemName: "figure.open.water.swim") }

            ProfileView()
                .tabItem { Image(systemName: "person") }
        }
        .tint(Color.theme)
    }
}

#Preview {
    DashboardTabView()
}
