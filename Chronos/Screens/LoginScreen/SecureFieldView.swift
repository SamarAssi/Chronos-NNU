//
//  SecureFieldView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct SecureFieldView: View {
    @Binding var password: String
    
    @State var showPassword = false
    @FocusState var focusField: Bool
    
    var title: String
    
    var body: some View {
        HStack {
            if showPassword {
                TextFieldView(
                    text: $password,
                    title: "Password"
                )
            } else  {
                secureFieldView
            }
        }
        .overlay(showPasswordButton, alignment: .trailing)
    }
}

extension SecureFieldView {
    var secureFieldView: some View {
        SecureField("", text: $password)
            .font(.system(size: 15))
            .padding(.leading)
            .offset(y: 10)
            .frame(height: 65)
            .background(fieldShapeView)
            .background(
                FieldContentView(
                    title: title,
                    isFocused: .constant(focusField),
                    content: $password
                )
                ,
                alignment: .leading
            )
            .focused($focusField)
    }
    
    var showPasswordButton: some View {
        HStack {
            if !password.isEmpty {
                ButtonView(
                    buttonIcon: showPassword ? "eye" : "eye.slash",
                    textButtonColor: Color.primary,
                    action: {
                        showPassword.toggle()
                    }
                )
                .padding(.trailing)
            }
        }
    }
    
    var fieldShapeView: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color(Constant.CustomColor.DARK_TURQUOISE))
    }
}

#Preview {
    SecureFieldView(
        password: .constant("ppp"),
        title: "Password"
    )
}
