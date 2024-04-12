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
    var fieldIcon: String
    var placeholder: String
    var isSecure: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .padding(.leading, 10)
                .font(.subheadline)
            HStack(spacing: 0) {
                Image(systemName: fieldIcon)
                    .foregroundStyle(Color.gray)
                
                if isSecure && !showPassword {
                    secureFieldView
                } else {
                    textFieldView
                }
                
                if isSecure {
                    showPasswordButtonView
                }
            }
            .padding(.leading, isSecure ? 14 : 8)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isFocused ? Color.darkTurquoise : Color.gray)
            }
        }
    }
}

extension TextFieldView {
    var textFieldView: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused)
            .font(.system(size: 15))
            .frame(height: 45)
            .autocapitalization(.none)
            .padding(.leading, 8)
    }
    
    var secureFieldView: some View {
        SecureField(placeholder, text: $text)
            .focused($isFocused)
            .font(.system(size: 15))
            .frame(height: 45)
            .autocapitalization(.none)
            .padding(.leading, 8)
        
    }
    
    var showPasswordButtonView: some View {
        MainButton(
            buttonIcon: showPassword ? "eye" : "eye.slash",
            textButtonColor: Color.gray,
            action: {
                showPassword.toggle()
            }
        )
        .padding(.trailing)
    }
}

#Preview {
    TextFieldView(
        text: .constant(""),
        label: "Email",
        fieldIcon: "envelope",
        placeholder: "Email Address",
        isSecure: false
    )
}
