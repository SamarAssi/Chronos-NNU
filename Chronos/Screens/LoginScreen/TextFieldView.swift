//
//  TextFieldView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var text: String
    
    @FocusState var focusField: Bool
    
    var title: String
    
    var body: some View {
        textFieldView
            .font(.system(size: 15))
            .padding(.leading)
            .offset(y: 10)
            .frame(height: 65)
            .background(fieldShapeView)
            .background(
                FieldContentView(
                    title: title,
                    isFocused: .constant(focusField),
                    content: $text
                ),
                alignment: .leading
            )
            .autocapitalization(.none)
    }
}

extension TextFieldView {
    var textFieldView: some View {
        TextField("", text: $text)
            .focused($focusField)
    }
    
    var fieldShapeView: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(Color(Constant.CustomColor.DARK_TURQUOISE))
    }
}

#Preview {
    TextFieldView(
        text: .constant(""),
        title: "Email Address"
    )
}
