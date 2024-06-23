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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(NavigationRouter())
                .environmentObject(locationManager)
        }
    }
}
