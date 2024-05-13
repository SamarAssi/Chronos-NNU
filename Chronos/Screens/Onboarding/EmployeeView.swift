//
//  EmployeeView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct EmployeeView: View {
    @State private var isLoading = false
    @State private var isCorrectId = true
    @State private var employeeResponse: OnboardingEmployeeRespone?
    @State private var id = ""
    @Binding var showFullScreen: Bool

    @EnvironmentObject var navigationRouter: NavigationRouter
    @Environment(\.dismiss) var dismiss

    var isDisabledNextButton: Bool {
        id.isEmpty ?
        true :
        false
    }

    var nextButtonBackgroundColor: Color {
        id.isEmpty ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(LocalizedStringKey("Enroll to Company"))
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .padding(.horizontal, 30)

            TextFieldView(
                text: $id,
                label: LocalizedStringKey("ID:"),
                placeholder: LocalizedStringKey("Enter company ID"),
                isSecure: false,
                isOptionl: false
            )
            .padding(.top)
            .padding(.horizontal, 30)

            if !isCorrectId {
                Text(LocalizedStringKey("This is a wrong id"))
                    .font(.subheadline)
                    .foregroundStyle(Color.red)
                    .fontDesign(.rounded)
                    .padding(.horizontal, 30)
            }

            Spacer()

            nextButtonView
        }
        .padding(.bottom, 20)
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

extension EmployeeView {
    var nextButtonView: some View {
        VStack(alignment: .center) {
            if isLoading {
                ActivityIndicatorView(type: .ballRotateChase, color: .theme)
                    .padding(.top, 510)
                    .padding(.horizontal, UIScreen.main.bounds.width / 2)
            } else {
                MainButton(
                    buttonText: LocalizedStringKey("Next"),
                    backgroundColor: nextButtonBackgroundColor,
                    action: {
                        onboardingAction()
                    }
                )
                .disabled(isDisabledNextButton)
                .padding(.horizontal, 30)
            }
        }
    }

    private func onboardingAction() {
        handleEmployeeOnboardingResponse { success in
            if success {
                showFullScreen = !success
                navigationRouter.isLoggedIn = success
            }
        }
    }

    private func handleEmployeeOnboardingResponse(
        completion: @escaping (Bool) -> Void
    ) {
        isLoading = true

        Task {
            do {
                employeeResponse = try await performEmployeeOnboardingRequest()
                isLoading = false
                isCorrectId = true
                completion(true)
            } catch let error {
                print(error)
                isLoading = false
                isCorrectId = false
                completion(false)
            }
        }
    }

    private func performEmployeeOnboardingRequest() async throws -> OnboardingEmployeeRespone {
        return try await AuthenticationClient.onboardingEmployee(id: id)
    }
}

#Preview {
    EmployeeView(showFullScreen: .constant(false))
        .environmentObject(NavigationRouter())
}
