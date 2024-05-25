//
//  ProgressLoader.swift
//  Chronos
//
//  Created by Samar Assi on 18/04/2024.
//

import Foundation
import SwiftUI

struct ProgressLoader: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        VStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                content
            }
        }
    }
}

extension View {
    func progressLoader(_ isLoading: Binding<Bool>) -> some View {
        modifier(ProgressLoader(isLoading: isLoading))
    }
}
