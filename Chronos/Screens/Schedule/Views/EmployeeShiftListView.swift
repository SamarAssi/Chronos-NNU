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

    var shifts: [ShiftRowUI]
    
    var body: some View {
        List(
            shifts,
            id: \.id
        ) { shift in
            Button(action: {
                selectedEmployee.0 = shift.employeeName
                selectedEmployee.1 = shift.employeeID
                dismiss()
            }) {
                Text(shift.employeeName)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    EmployeeShiftListView(
        selectedEmployee: .constant((nil, nil)),
        shifts: []
    )
}
