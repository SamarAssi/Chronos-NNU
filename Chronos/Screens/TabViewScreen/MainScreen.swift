//
//  MainScreen.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct MainScreen: View {
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
            
            Text("hello4")
                .tabItem { Image(systemName: "person") }
        }
    }
}

#Preview {
    MainScreen()
}
