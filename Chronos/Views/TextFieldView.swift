//
//  TextFieldView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct TextFieldView: View {
    @State var showPassword = false
    @Binding var text: String
    @FocusState var isFocused: Bool

    var label: LocalizedStringKey
    var placeholder: LocalizedStringKey
    var isSecure: Bool

    var borderColor: Color {
        isFocused || !text.isEmpty ?
        Color.theme :
        Color.clear
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.black)
                .padding(.horizontal, 10)

            HStack {
                currentTextField

                if isSecure {
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
    }
}

extension TextFieldView {
    var currentTextField: some View {
        VStack {
            if isSecure && !showPassword {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .font(.system(size: 15))
        .frame(height: 45)
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
        isSecure: false
    )
}
