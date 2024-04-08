//
//  TextFieldView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    
    @State var showPassword = false
    
    var isSecure: Bool
    var placeholder: String
    var fieldIcon: String
    
    var body: some View {
        VStack {
            if isSecure && !showPassword {
                secureFieldView
            } else {
                textFieldView
            }
        }
    }
}

extension TextFieldView {
    var textFieldView: some View {
        HStack(spacing: isSecure ? 10 : 8) {
            Image(systemName: fieldIcon)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .frame(height: 45)
                .autocapitalization(.none)
            
            if !text.isEmpty && showPassword {
                showPasswordButtonView
            }
        }
        .padding(.leading, isSecure ? 12 : 8)
        .overlay {
            fieldShapeView
        }
    }
    
    var secureFieldView: some View {
        HStack(spacing: 10) {
            Image(systemName: fieldIcon)
            
            SecureField(placeholder, text: $text)
                .font(.system(size: 15))
                .frame(height: 45)
                .autocapitalization(.none)
            
            if !text.isEmpty {
                showPasswordButtonView
            }
        }
        .padding(.leading, 12)
        .overlay {
            fieldShapeView
        }
    }
    
    var fieldShapeView: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color(Constant.CustomColor.DARK_TURQUOISE))
    }
    
    var showPasswordButtonView: some View {
        MainButton(
            buttonIcon: showPassword ? "eye" : "eye.slash",
            textButtonColor: Color.primary,
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
        isSecure: false,
        placeholder: "Email Address",
        fieldIcon: "envelope"
    )
}
