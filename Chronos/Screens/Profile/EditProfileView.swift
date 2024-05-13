//
//  EditProfileView.swift
//  Chronos
//
//  Created by Samar Assi on 09/05/2024.
//

import SwiftUI

struct EditProfileView: View {
    @State private var isLoading = false
    @State private var textFields: [TextFieldModel] = []

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            VStack {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 95)

                Text(LocalizedStringKey("Michael Mitc"))
                    .font(.system(size: 20, weight: .medium))
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal)
            .padding(.bottom)

            textFieldListView

            registerButtonView
        }
        .fontDesign(.rounded)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "arrow.left")
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
            }
        }
        .onAppear {
            setTextFields()
        }
    }
}

extension EditProfileView {
    var textFieldListView: some View {
        List(textFields.indices, id: \.self) { index in
            TextFieldView(
                text: Binding<String>(
                    get: { textFields[index].text },
                    set: { newValue in
                        textFields[index].text = newValue
                    }
                ),
                label: textFields[index].label,
                placeholder: textFields[index].placeholder,
                isSecure: textFields[index].isSecure,
                isOptionl: textFields[index].isOptional
            )
            .listRowSeparator(.hidden)
            .scrollIndicators(.hidden)
            .padding(.horizontal, 10)
            .keyboardType(textFields[index].keyboardType)
        }
        .listStyle(PlainListStyle())
    }

    var registerButtonView: some View {
        VStack(alignment: .center) {
            if isLoading {
                ActivityIndicatorView(type: .ballRotateChase, color: .theme)
                    .padding(.top, 45)
                    .padding(.horizontal, UIScreen.main.bounds.width / 2)
            } else {
                MainButton(
                    buttonText: LocalizedStringKey("Update"),
                    backgroundColor: Color.theme,
                    action: {
                    }
                )
                .padding(.horizontal, 30)
            }
        }
        .frame(height: 90)
    }

    private func setTextFields() {
        textFields = [
            TextFieldModel(
                text: "",
                label: LocalizedStringKey("First Name"),
                placeholder: "Enter first name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Last Name",
                placeholder: "Enter last name",
                isSecure: false,
                keyboardType: .asciiCapable,
                isDisabled: false,
                isOptional: false
            ),
            TextFieldModel(
                text: "",
                label: "Phone Number",
                placeholder: "Enter your phone number",
                isSecure: false,
                keyboardType: .phonePad,
                isDisabled: false,
                isOptional: false
            )
        ]
    }
}

#Preview {
    EditProfileView()
}
