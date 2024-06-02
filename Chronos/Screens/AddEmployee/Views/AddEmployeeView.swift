//
//  AddEmployeeView.swift
//  Chronos
//
//  Created by Samar Assi on 30/05/2024.
//

import SwiftUI

struct AddEmployeeView: View {

    @Environment(\.dismiss) var dismiss
    @State private var addEmployeeData: [TextFieldModel] = TextFieldModel.addEmployeeData
    @State private var isSelectedJob = false

    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 5
            ) {
                titleView
                textFieldList
                addEmployeeButtonView
            }
            .fontDesign(.rounded)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButtonView
                }
            }
        }
    }
}

extension AddEmployeeView {
    var titleView: some View {
        Text(LocalizedStringKey("Add Employee"))
            .foregroundStyle(Color.theme)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal, 30)
    }
    
    var textFieldList: some View {
        List {
            Section {
                ForEach(addEmployeeData) { textField in
                    TextFieldView(textFieldModel: textField)
                        .listRowSeparator(.hidden)
                        .padding(.horizontal, 10)
                }
            }
            
            Section {
                jobSelectionView
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
    
    var jobSelectionView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Select your job:"))
                .font(.subheadline)
                .padding(.horizontal, 10)
            
            ForEach(0..<1) { _ in
                displayJob(jobTitle: "iOS")
            }
        }
        .padding(.horizontal, 10)
    }

    var addEmployeeButtonView: some View {
        MainButton(
            isLoading: .constant(false),
            buttonText: LocalizedStringKey("Register"),
            backgroundColor: Color.theme,
            action: {
               
            }
        )
        .padding(.horizontal, 30)
        .disabled(false)
        .frame(height: 70)
    }
    
    var backButtonView: some View {
        Image(systemName: "lessthan")
            .scaleEffect(0.6)
            .scaleEffect(x: 1, y: 2)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    private func displayJob(jobTitle: String) -> some View {
        JobListCellView(
            isSelectedJob: $isSelectedJob,
            jobTitle: jobTitle
        )
        .onTapGesture {
            isSelectedJob.toggle()
        }
    }
}

#Preview {
    AddEmployeeView()
}
