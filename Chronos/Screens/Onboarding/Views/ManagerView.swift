//
//  ManagerView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct ManagerView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject private var managerModel = ManagerModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    @Binding var showFullScreen: Bool

    var isDisabledRegisterButton: Bool {
        isEmptyFields() ?
        true :
        false
    }

    var registerButtonBackgroundColor: Color {
        isEmptyFields() ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            Text(LocalizedStringKey("Register Company"))
                .font(.system(
                    size: 25,
                    weight: .bold,
                    design: .rounded
                ))

            TextFieldView(
                textFieldModel: managerModel.textFieldModels
            )
            .padding(.top)

            TextEditorView(
                text: $managerModel.description,
                label: "Description",
                placeholder: "Enter company description"
            )

            Spacer()

            registerButtonView
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButtonView
            }
        }
    }
}

extension ManagerView {
    
    var backButtonView: some View {
        Image(systemName: "chevron.left")
            .scaleEffect(0.9)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }

    var registerButtonView: some View {
        MainButton(
            isLoading: $managerModel.isLoading,
            isEnable: .constant(true),
            buttonText: "Register",
            backgroundColor: registerButtonBackgroundColor,
            action: {
                onboardingAction()
            }
        )
        .disabled(isDisabledRegisterButton)
        .frame(height: 60)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func onboardingAction() {
        managerModel.handleManagerOnboardingResponse { success in
            showFullScreen = !showFullScreen
            navigationRouter.isLoggedIn = success
            editEmployeeType()
        }
    }

    private func isEmptyFields() -> Bool {
        return managerModel.textFieldModels.text.isEmpty || managerModel.description.isEmpty
    }

    private func editEmployeeType() {
        KeychainManager.shared.save(
            String(1),
            key: KeychainKeys.employeeType.rawValue
        )
    }
}

#Preview {
    ManagerView(showFullScreen: .constant(false))
        .environmentObject(NavigationRouter())
}
