//
//  MainButton.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct MainButton: View {

    @Binding var isLoading: Bool
    @Binding var isEnable: Bool

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
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            Button(action: action) {
                Text(buttonText)
                    .foregroundStyle(Color.white)
                    .fontWeight(.bold)
                    .frame(height: 45)
                    .frame(maxWidth: .infinity)
                    .background(isEnable ? backgroundColor : .gray.opacity(0.2))
                    .disabled(isEnable)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .fontDesign(.rounded)
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MainButton(
        isLoading: .constant(true),
        isEnable: .constant(true),
        buttonText: "Login",
        backgroundColor: Color.theme,
        action: {}
    )
}
