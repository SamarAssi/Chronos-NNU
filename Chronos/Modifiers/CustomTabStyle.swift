//
//  CustomTabStyle.swift
//  Chronos
//
//  Created by Samar Assi on 25/06/2024.
//

import Foundation
import SwiftUI

struct CustomTabStyle: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .tint(.theme)
                .onAppear {
                    let appearance = UITabBarAppearance()
                    appearance.backgroundEffect = UIBlurEffect(style: .regular)
                    appearance.backgroundColor = UIColor(Color.clear)
                    
                    UITabBar.appearance().standardAppearance = appearance
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                    
                    UITabBar.appearance().unselectedItemTintColor = .gray
                }
        } else {
            content
                .tint(.theme)
                .onAppear {
                    UITabBar.appearance().backgroundColor = UIColor.clear
                    UITabBar.appearance().isTranslucent = true
                    UITabBar.appearance().unselectedItemTintColor = .gray
                }
        }
    }
}

extension View {
    func customTabStyle() -> some View {
        self.modifier(CustomTabStyle())
    }
}
