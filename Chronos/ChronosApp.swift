//
//  ChronosApp.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

@main
struct ChronosApp: App {
    
    @StateObject var locationManager = LocationManager()

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.theme]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.theme]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationRouter())
                .environmentObject(locationManager)
        }
    }
}
