//
//  RadioButtonView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct RadioButtonView: View {
    var isSelected: Bool
    let label: LocalizedStringKey
    let details: LocalizedStringKey

    var innerCircleColor: Color {
        isSelected ?
        Color.theme :
        Color.clear
    }

    var outlineColor: Color {
        isSelected ?
        Color.theme :
        Color.gray
    }

    var borderColor: Color {
        isSelected ?
        Color.theme :
        Color.silver
    }

    var body: some View {
        HStack(
            alignment: .center,
            spacing: 10
        ) {
            circleView
            descriptionView
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 60)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(borderColor)
        )
    }
}

extension RadioButtonView {
    var circleView: some View {
        Circle()
            .fill(innerCircleColor)
            .padding(4)
            .overlay(
                Circle()
                    .stroke(outlineColor, lineWidth: 1)
            )
            .frame(width: 20, height: 20)
    }

    var descriptionView: some View {
        VStack(
            alignment: .leading,
            spacing: 2
        ) {
            Text(label)
                .font(.system(size: 15))

            Text(details)
                .foregroundStyle(Color.secondary)
                .font(.system(size: 13))
        }
    }
}

#Preview {
    RadioButtonView(
        isSelected: false,
        label: "Manager",
        details: "Manage your team effortlessly"
    )
}
