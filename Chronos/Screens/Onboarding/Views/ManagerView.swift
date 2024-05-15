//
//  ManagerView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct ManagerView: View {
    
    @State private var isLoading = false
    @State private var name = ""
    @State private var description = ""
    @State private var managerResponse: ManagerOnboardingResponse?

    @Binding var showFullScreen: Bool

    @EnvironmentObject var navigationRouter: NavigationRouter
    @Environment(\.dismiss) var dismiss

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
        VStack {
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                Text(LocalizedStringKey("Register Company"))
                    .font(.system(size: 25, weight: .bold, design: .rounded))

                TextFieldView(
                    text: $name,
                    label: LocalizedStringKey("Company Name:"),
                    placeholder: LocalizedStringKey("Enter company name"),
                    isSecure: false,
                    isOptionl: false
                )
                .padding(.top)

                TextEditorView(
                    text: $description,
                    label: LocalizedStringKey("Description"),
                    placeholder: LocalizedStringKey("Enter company description")
                )
            }

            Spacer()

            registerButtonView
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
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

extension ManagerView {
    var registerButtonView: some View {
        MainButton(
            isLoading: $isLoading,
            buttonText: LocalizedStringKey("Register"),
            backgroundColor: registerButtonBackgroundColor,
            action: {
                onboardingAction()
            }
        )
        .disabled(isDisabledRegisterButton)
        .frame(height: 60)
    }

    private func onboardingAction() {
        handleManagerOnboardingResponse { success in
            showFullScreen = !showFullScreen
            navigationRouter.isLoggedIn = success
        }
    }

    private func handleManagerOnboardingResponse(
        completion: @escaping (Bool) -> Void
    ) {
        isLoading = true

        Task {
            do {
                managerResponse = try await performManagerOnboardingRequest()
                isLoading = false
                saveCompanyInvitationId()
                completion(true)
            } catch let error {
                print(error)
                isLoading = false
                completion(false)
            }
        }
    }

    private func performManagerOnboardingRequest() async throws -> ManagerOnboardingResponse {
        return try await AuthenticationClient.onboardingManager(
            name: name,
            description: description
        )
    }

    private func isEmptyFields() -> Bool {
        return name.isEmpty || description.isEmpty
    }

    private func saveCompanyInvitationId() {
        if let response = managerResponse {
            KeychainManager.shared.save(
                response.companyInvitationId,
                key: KeychainKeys.companyInvitationId.rawValue
            )
        }
    }
}

#Preview {
    ManagerView(showFullScreen: .constant(false))
        .environmentObject(NavigationRouter())
}
