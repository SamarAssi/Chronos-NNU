//
//  EmployeesSelectorView.swift
//  Chronos
//
//  Created by Bassam Hillo on 28/06/2024.
//

import SwiftUI

struct EmployeeChoice: Identifiable {
    var id = UUID()
    var employee: Employee
    var isSelected: Bool
}

struct EmployeesSelectorView: View {

    @Binding var employees: [EmployeeChoice]
    let question: String

    var body: some View {
        List {
            Image("employee")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 10)

            Text(question)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .listRowSeparator(.hidden)

            CheckBox(
                value: Binding(
                    get: {
                        employees.allSatisfy { $0.isSelected }
                    },
                    set: { newValue in
                        employees.indices.forEach {
                            employees[$0].isSelected = newValue
                        }
                    }),
                label: "Select all employees"
            )

            ForEach($employees) { $choice in
                CheckBox(
                    value: $choice.isSelected,
                    label: choice.employee.firstName + " " + choice.employee.lastName
                )
            }
        }
    }
}

#Preview {
    EmployeesSelectorView(
        employees: .constant(
            [
                EmployeeChoice(
                    employee: Employee(
                        id: "UUID",
                        username: "Test" ,
                        firstName: "Bassam",
                        lastName: "Hillo",
                        jobs: []
                    ),
                    isSelected: true
                ),
                EmployeeChoice(
                    employee: Employee(
                        id: "1",
                        username: "Test" ,
                        firstName: "Bassam",
                        lastName: "Hillo",
                        jobs: []
                    ),
                    isSelected: false
                )

            ]
        ), question: "Select employees to assign to the shift"
    )
}
