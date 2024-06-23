//
//  EmployeeView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct EmployeeView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject private var employeeModel = EmployeeModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    @Binding var showFullScreen: Bool

    var isDisabledNextButton: Bool {
        isEmptyField() ?
        true :
        false
    }

    var nextButtonBackgroundColor: Color {
        isEmptyField() ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        VStack {
            VStack(
                alignment: .leading,
                spacing: 10
            ) {
                Text(LocalizedStringKey("Enroll to Company"))
                    .font(.system(size: 25, weight: .bold, design: .rounded))
                    .padding(.horizontal, 30)

                TextFieldView(textFieldModel: employeeModel.textFieldModels)
                    .padding(.top)
                    .padding(.horizontal, 30)

                if !employeeModel.isCorrectId {
                    Text(LocalizedStringKey("This is a wrong id"))
                        .font(.subheadline)
                        .foregroundStyle(Color.red)
                        .fontDesign(.rounded)
                        .padding(.horizontal, 30)
                }
            }

            Spacer()

            nextButtonView
        }
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

extension EmployeeView {

    var nextButtonView: some View {
        MainButton(
            isLoading: $employeeModel.isLoading,
            isEnable: .constant(true),
            buttonText: LocalizedStringKey("Next"),
            backgroundColor: nextButtonBackgroundColor,
            action: {
                onboardingAction()
            }
        )
        .disabled(isDisabledNextButton)
        .padding(.horizontal, 30)
        .frame(height: 60)
    }

    private func onboardingAction() {
        employeeModel.handleEmployeeOnboardingResponse { success in
            if success {
                showFullScreen = !success
                navigationRouter.isLoggedIn = success
                editEmployeeType()
            }
        }
    }

    private func isEmptyField() -> Bool {
        return employeeModel.textFieldModels.text.isEmpty
    }

    private func editEmployeeType() {
        KeychainManager.shared.save(
            String(0),
            key: KeychainKeys.employeeType.rawValue
        )
    }
}

#Preview {
    EmployeeView(showFullScreen: .constant(false))
        .environmentObject(NavigationRouter())
}
