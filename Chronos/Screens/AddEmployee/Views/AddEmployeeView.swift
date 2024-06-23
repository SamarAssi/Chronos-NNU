//
//  AddEmployeeView.swift
//  Chronos
//
//  Created by Samar Assi on 30/05/2024.
//

import SwiftUI
import SimpleToast

struct AddEmployeeView: View {

    @StateObject private var addEmployeeModel = AddEmployeeModel()
    @ObservedObject var employeeListModel: EmployeeListModel
    @Environment(\.dismiss) var dismiss

    @State private var isPhoneNumberInvalid = false
    @State private var isSamePassword = false
    
    @Binding var isEditing: Bool
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )

    var isAddButtonDisabled: Bool {
        if areEmptyFields() {
            return true
        } else if !PasswordValidationManager.shared.isPasswordValid() {
            return true
        } else {
            return false
        }
    }
    
    var addButtonBackgroundColor: Color {
        isAddButtonDisabled ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                textFieldList
                addEmployeeButtonView
            }
            .fontDesign(.rounded)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButtonView
                }
                ToolbarItem(placement: .topBarLeading) {
                    titleView
                }
            }
        }
        .onAppear {
            addEmployeeModel.getJobsList()
        }
        .onDisappear {
            employeeListModel.getEmployeesList()
            isEditing = true
        }
        .simpleToast(
            isPresented: $isPhoneNumberInvalid,
            options: toastOptions
        ) {
            invalidPhoneNumberToast
        }
        .simpleToast(
            isPresented: $isSamePassword,
            options: toastOptions
        ) {
            passwordMismatchToast
        }
        .simpleToast(
            isPresented: $addEmployeeModel.isUsernameInvalid,
            options: toastOptions
        ) {
            invalidUsernameToast
        }
    }
}

extension AddEmployeeView {

    var constraintsView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Password must meet the following requirements:"))
                .padding(.bottom, 4)

            ForEach(PasswordValidationManager.shared.constraints) { constraint in
                Text(constraint.text)
                    .foregroundColor(
                        constraint.passwordConstraint ?
                        Color.theme :
                        Color.secondary
                    )
            }
        }
        .font(.subheadline)
        .padding(.top, 5)
        .padding(.horizontal, 15)
    }

    var titleView: some View {
        Text(LocalizedStringKey("Add Employee"))
            .font(.title2)
            .fontWeight(.bold)
            .fontDesign(.rounded)
    }
    
    var textFieldList: some View {
        List {
            Section {
                ForEach(
                    addEmployeeModel.textFields.indices,
                    id: \.self
                ) { index in
                    TextFieldView(textFieldModel: addEmployeeModel.textFields[index])
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, 10)
                        .onChange(of: addEmployeeModel.textFields[4].text) {
                            PasswordValidationManager.shared.validatePassword(
                                password: addEmployeeModel.textFields[4].text
                            )
                        }
                    
                    if index == 3 {
                        if let jobsResponse = addEmployeeModel.jobsResponse {
                            ScrollableListView(
                                selectedItems: $addEmployeeModel.selectedJobs,
                                label: "Select the job/s:",
                                items: jobsResponse.jobs,
                                withIcon: false
                            )
                            .padding(.horizontal, 10)
                        }
                    }
                }
            }

            Section {
                constraintsView
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }

    var addEmployeeButtonView: some View {
        MainButton(
            isLoading: $addEmployeeModel.isLoading,
            isEnable: .constant(true),
            buttonText: LocalizedStringKey("Add"),
            backgroundColor: addButtonBackgroundColor,
            action: {
                isPhoneNumberInvalid = !isValidPhoneNumber(
                    addEmployeeModel.textFields[3].text
                )
                isSamePassword = !checkIsSamePassword()
                if !isPhoneNumberInvalid && checkIsSamePassword() {
                    addEmployeeModel.handleRegistrationResponse { success in
                        if success {
                            dismiss.callAsFunction()
                        }
                    }
                }
            }
        )
        .padding(.horizontal, 30)
        .disabled(isAddButtonDisabled)
        .frame(height: 70)
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var invalidPhoneNumberToast: some View {
        ToastView(
            type: .error,
            message: LocalizedStringKey("Invalid phone number")
        )
        .padding(.horizontal, 30)
    }

    var passwordMismatchToast: some View {
        ToastView(
            type: .error,
            message: LocalizedStringKey("Password mismatch")
        )
        .padding(.horizontal, 30)
    }

    var invalidUsernameToast: some View {
        ToastView(
            type: .error,
            message: LocalizedStringKey("Username is invalid")
        )
        .padding(.horizontal, 30)
    }
}

extension AddEmployeeView {

    private func areEmptyFields() -> Bool {
        for index in addEmployeeModel.textFields.indices {
            if addEmployeeModel.textFields[index].text.isEmpty && index != 3 {
                return true
            }
        }
        if addEmployeeModel.selectedJobs.isEmpty {
            return true
        }
        return false
    }
    
    private func isValidPhoneNumber(
        _ value: String
    ) -> Bool {
        guard !value.isEmpty else { return true }
        let phoneRegex = #"^\d{10}$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return predicate.evaluate(with: value)
    }
    
    private func checkIsSamePassword() -> Bool {
        return addEmployeeModel.textFields[4].text == addEmployeeModel.textFields[5].text
    }
}

#Preview {
    AddEmployeeView(
        employeeListModel: EmployeeListModel(),
        isEditing: .constant(false)
    )
}
