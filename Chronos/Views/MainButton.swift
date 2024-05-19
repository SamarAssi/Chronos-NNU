//
//  MainButton.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct MainButton: View {
    @Binding var isLoading: Bool

    var buttonText: LocalizedStringKey
    var backgroundColor: Color
    var action: () -> Void

    var body: some View {
        if isLoading {
            ProgressView()
                .progressViewStyle(
                    CircularProgressViewStyle(tint: Color.theme)
                )
                .scaleEffect(1.5, anchor: .center)
        } else {
            Button(action: action) {
                Text(buttonText)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .cornerRadius(15)
                    .fontDesign(.rounded)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MainButton(
        isLoading: .constant(true),
        buttonText: "Login",
        backgroundColor: Color.theme,
        action: {}
    )
}
