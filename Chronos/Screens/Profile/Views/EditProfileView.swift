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
            updateButtonView
        }
        .onAppear {
            textFieldModels[0].text = fetchFirstName()
            textFieldModels[1].text = fetchLastName()
            textFieldModels[2].text = fetchPhoneNumber()
        }
        .fontDesign(.rounded)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButtonView
            }
        }
    }
}

extension EditProfileView {
    
    var backButtonView: some View {
        Image(systemName: "chevron.left")
            .scaleEffect(0.9)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }

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

    var updateButtonView: some View {
        MainButton(
            isLoading: $isLoading,
            isEnable: .constant(true),
            buttonText: "Update",
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
    
    private func fetchFirstName() -> String {
        if let firstName = KeychainManager.shared.fetch(
            key: KeychainKeys.firstName.rawValue
        ) {
            return firstName
        }

        return ""
    }
    
    private func fetchLastName() -> String {
        if let lastName = KeychainManager.shared.fetch(
            key: KeychainKeys.lastName.rawValue
        ) {
            return lastName
        }

        return ""
    }
    
    private func fetchPhoneNumber() -> String {
        if let phoneNumber = KeychainManager.shared.fetch(
            key: KeychainKeys.phoneNumber.rawValue
        ) {
            return phoneNumber
        }

        return ""
    }
}

#Preview {
    EditProfileView()
}
