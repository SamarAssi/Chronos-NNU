//
//  EmployeeShiftListView.swift
//  Chronos
//
//  Created by Samar Assi on 27/06/2024.
//

import SwiftUI

struct EmployeeShiftListView: View {

    @Environment(\.dismiss) var dismiss
    @Binding var selectedEmployee: (String?, String?)
    @Binding var showAllEmployees: Bool

    var shifts: [ShiftRowUI]
    var employees: [Employee]

    var body: some View {
        List {
            Section {
                ForEach(employees) { employee in
                    Button(action: {
                        selectedEmployee.0 = employee.username
                        selectedEmployee.1 = employee.id
                        showAllEmployees = false
                        
                        dismiss.callAsFunction()
                    }) {
                        Text(employee.username)
                    }
                }
            }
            
            Section {
                Button(action: {
                    showAllEmployees = true
                    dismiss.callAsFunction()
                }, label: {
                    Text(LocalizedStringKey("All Employees"))
                })
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    EmployeeShiftListView(
        selectedEmployee: .constant((nil, nil)),
        showAllEmployees: .constant(false),
        shifts: [],
        employees: []
    )
}
