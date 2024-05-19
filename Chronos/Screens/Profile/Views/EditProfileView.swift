//
//  EditProfileView.swift
//  Chronos
//
//  Created by Samar Assi on 09/05/2024.
//

import SwiftUI

struct EditProfileView: View {
    @State private var isLoading = false
    @State private var textFieldModels: [TextFieldModel] = TextFieldModel.editingData

    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            headerSectionView
            textFieldListView
            registerButtonView
        }
        .fontDesign(.rounded)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "lessthan")
                    .scaleEffect(0.6)
                    .scaleEffect(x: 1, y: 2)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
            }
        }
    }
}

extension EditProfileView {
    var headerSectionView: some View {
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
    }

    var textFieldListView: some View {
        List(textFieldModels) { textFieldModel in
            TextFieldView(
                textFieldModel: textFieldModel
            )
            .listRowSeparator(.hidden)
            .scrollIndicators(.hidden)
            .padding(.horizontal, 10)
        }
        .listStyle(PlainListStyle())
    }

    var registerButtonView: some View {
        MainButton(
            isLoading: $isLoading,
            buttonText: LocalizedStringKey("Update"),
            backgroundColor: Color.theme,
            action: {
                // TODO: update your personal information
            }
        )
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 30)
        .padding(.bottom)
        .frame(height: 60)
    }
}

#Preview {
    EditProfileView()
}
