//
//  TextFieldView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct TextFieldView: View {
    @State private var showPassword = false
    @FocusState var isFocused: Bool

    @ObservedObject var textFieldModel: TextFieldModel

    var borderColor: Color {
        isFocused || !textFieldModel.text.isEmpty ?
        Color.theme :
        Color.clear
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            labelView

            HStack {
                currentTextField

                if textFieldModel.isSecure {
                    showPasswordButtonView
                }
            }
            .focused($isFocused)
            .padding(.horizontal, 10)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor)
            }
        }
        .keyboardType(textFieldModel.keyboardType)
    }
}

extension TextFieldView {
    var labelView: some View {
        VStack {
            if !textFieldModel.isOptional {
                Text(textFieldModel.label)
                    .font(.subheadline)
            } else {
                Text(textFieldModel.label)
                    .font(.subheadline)
                +
                Text(" (Optional)")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.black.opacity(0.8))
            }
        }
        .padding(.horizontal, 10)
    }

    var currentTextField: some View {
        VStack {
            if textFieldModel.isSecure && !showPassword {
                SecureField(
                    textFieldModel.placeholder,
                    text: $textFieldModel.text
                )
            } else {
                TextField(
                    textFieldModel.placeholder,
                    text: $textFieldModel.text
                )
            }
        }
        .font(.system(size: 15))
        .frame(height: 45)
        .textInputAutocapitalization(.never)
    }

    var showPasswordButtonView: some View {
        Button {
            isFocused = true
            showPassword.toggle()
        } label: {
            Image(systemName: showPassword ? "eye" : "eye.slash")
                .foregroundColor(.gray)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TextFieldView(
        textFieldModel: TextFieldModel(
            text: "",
            label: "",
            placeholder: "",
            isSecure: true,
            keyboardType: .alphabet,
            isDisabled: true,
            isOptional: true
        )
    )
}
