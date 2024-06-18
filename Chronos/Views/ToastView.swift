//
//  ToastView.swift
//  Chronos
//
//  Created by Samar Assi on 06/05/2024.
//

import SwiftUI

struct ToastView: View {

    var type: ToastTypes
    var message: LocalizedStringKey

    var itemsColor: Color {
        switch type {
        case .success:
            return Color.green
        case .warning:
            return Color.darkYellow
        case .info:
            return Color.blue
        case .error:
            return Color.red
        }
    }

    var iconName: String {
        switch type {
        case .success:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .info:
            return "info.circle.fill"
        case .error:
            return "x.circle.fill"
        }
    }

    var body: some View {
        HStack(
            spacing: 8
        ) {
            Image(systemName: iconName)
                .foregroundStyle(itemsColor)
                .font(.title3)

            Text(message)
                .font(.system(size: 15, weight: .medium, design: .rounded))

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(itemsColor.opacity(0.6))
        )
    }
}

#Preview {
    ToastView(
        type: .error,
        message: "Invalid number"
    )
}
