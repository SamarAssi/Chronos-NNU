//
//  FooterButton.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import SwiftUI

struct FooterButton: View {
    var title: String
    var buttonText: String
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 5) {
            Spacer()
            Text(title)
            MainButton(
                buttonText: buttonText,
                textButtonColor: Color.darkTurquoise,
                action: action
            )
            .fontWeight(.bold)
            Spacer()
        }
        .font(.system(size: 15))
    }
}

#Preview {
    FooterButton(
        title: "Didn't have an account?",
        buttonText: "Register",
        action: {}
    )
}
