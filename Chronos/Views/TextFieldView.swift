//
//  TextFieldView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct TextFieldView: View {

    @State private var showPassword = false
    @Binding var text: String
    @FocusState var isFocused: Bool

    var label: String
    var placeholder: String
    var isSecure: Bool

    var borderColor: Color {
        isFocused || !text.isEmpty ?
        Color.blue :
        Color.gray
    }

    var titleColor: Color {
        isFocused || !text.isEmpty ?
        Color.blue :
        Color.black
    }

    var body: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(titleColor)

                currentTextField
            }
            .padding(.vertical, 6)

            if isSecure {
                showPasswordButtonView
            }
        }
        .focused($isFocused)
        .padding(.horizontal, 10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor)
        }
        .onTapGesture {
            isFocused = true
        }
    }
}

extension TextFieldView {

    var currentTextField: some View {
        Group {
            if isSecure && !showPassword {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .font(.system(size: 15))
        .frame(height: 20)
        .autocapitalization(.none)
        .padding(.vertical, 0)
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
        text: .constant(""),
        label: "Email",
        placeholder: "Email Address",
        isSecure: true
    )
}
