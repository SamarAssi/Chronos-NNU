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
                .font(.system(size: 15))
            Button {
                action()
            } label: {
                Text(buttonText)
                    .foregroundStyle(Color.theme)
                    .fontWeight(.bold)
            }
            Spacer()
        }
    }
}

#Preview {
    FooterButton(
        title: "Didn't have an account?",
        buttonText: "Register",
        action: {}
    )
}
