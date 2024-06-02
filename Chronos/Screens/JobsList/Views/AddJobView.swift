//
//  AddJobView.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import SwiftUI

struct AddJobView: View {
    @ObservedObject var jobsListModel: JobsListModel
    @State private var textField: TextFieldModel = TextFieldModel.addJobData
    @Environment(\.dismiss) var dismiss
    
    var isButtonDisabled: Bool {
        return isEmptyField()
    }

    var addButtonBackgroundColor: Color {
        isEmptyField() ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                titleView
                TextFieldView(textFieldModel: textField)
                Spacer()
                addButtonView
            }
            .fontDesign(.rounded)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButtonView
                }
            }
        }
    }
}

extension AddJobView {
    var titleView: some View {
        Text("Add Job")
            .font(.title)
            .fontWeight(.bold)
    }
    
    var addButtonView: some View {
        MainButton(
            isLoading: $jobsListModel.isLoading,
            buttonText: "Add",
            backgroundColor: addButtonBackgroundColor,
            action: {
                jobsListModel.handleUpdateJobResponse(
                    name: textField.text
                )
            }
        )
        .disabled(isButtonDisabled)
    }
    
    var backButtonView: some View {
        Image(systemName: "lessthan")
            .scaleEffect(0.6)
            .scaleEffect(x: 1, y: 2)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    private func isEmptyField() -> Bool {
        return textField.text.isEmpty
    }
}

#Preview {
    AddJobView(jobsListModel: JobsListModel())
}
