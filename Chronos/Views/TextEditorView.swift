//
//  TextEditorView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct TextEditorView: View {
    @Binding var text: String
    @FocusState var isFocused: Bool

    var label: LocalizedStringKey
    var placeholder: LocalizedStringKey

    var borderColor: Color {
        isFocused || !text.isEmpty ?
        Color.theme :
        Color.clear
    }

    var body: some View {
        VStack(
            alignment: .leading
        ) {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 10)

            ZStack(
                alignment: .topLeading
            ) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .padding(11)
                        .padding(.top, 5)
                }

                textEditorView
            }
        }
        .fontDesign(.rounded)
    }
}

extension TextEditorView {
    var textEditorView: some View {
        TextEditor(text: $text)
            .font(.system(size: 15))
            .textInputAutocapitalization(.never)
            .tint(Color.theme)
            .focused($isFocused)
            .scrollContentBackground(.hidden)
            .padding(8)
            .frame(height: 300)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor)
            }
    }
}

#Preview {
    TextEditorView(
        text: .constant(""),
        label: "Description",
        placeholder: "Enter company description"
    )
}
