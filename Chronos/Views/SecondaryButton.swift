//
//  SecondaryButton.swift
//  Chronos
//
//  Created by Samar Assi on 22/06/2024.
//

import SwiftUI

struct SecondaryButton<Label: View>: View {
    
    var label: Label
    var borderColor: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            label
                .fontDesign(.rounded)
                .fontWeight(.bold)
                .foregroundStyle(borderColor)
                .frame(height: 45)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(borderColor)
                )
        }
    }
}

#Preview {
    SecondaryButton(
        label: HStack {
            Image(systemName: "location.fill")
            Text("Select your location")
        },
        borderColor: Color.theme,
        action: {
            
        }
    )
}
