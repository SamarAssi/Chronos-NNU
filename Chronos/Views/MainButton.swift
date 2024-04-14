//
//  MainButton.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct MainButton: View {
    var buttonText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
        }
        .foregroundStyle(Color.white)
        .fontWeight(.bold)
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(Color.theme)
        .cornerRadius(15)
    }
}

#Preview {
    MainButton(
        buttonText: "Login",
        action: {}
    )
}
