//
//  EditProfileView.swift
//  Chronos
//
//  Created by Samar Assi on 09/05/2024.
//

import SwiftUI

struct EditProfileView: View {

    @Environment(\.dismiss) var dismiss

    @State private var isLoading = false
    @State private var textFieldModels: [TextFieldModel] = TextFieldModel.editingData

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

            Text(fetchFullName())
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

    private func fetchFullName() -> String {
        if let fullName = KeychainManager.shared.fetch(
            key: KeychainKeys.fullName.rawValue
        ) {
            return fullName
        }

        return ""
    }
}

#Preview {
    EditProfileView()
}
