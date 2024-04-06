//
//  ButtonView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct ButtonView: View {
    var buttonText: String?
    var buttonIcon: String?
    var textButtonColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if let buttonText = buttonText {
                Text(buttonText)
            }
            if let buttonIcon = buttonIcon {
                Image(systemName: buttonIcon)
            }
        }
        .foregroundStyle(textButtonColor)
    }
}

#Preview {
    ButtonView(
        textButtonColor: Color.black,
        action: {}
    )
}
