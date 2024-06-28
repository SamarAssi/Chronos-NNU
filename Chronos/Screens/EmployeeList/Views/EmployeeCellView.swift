//
//  EmployeeCellView.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import SwiftUI

struct EmployeeCellView: View {
    var employee: Employee

    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 50)
            .overlay {
                rowContentView
            }
    }
}

extension EmployeeCellView {

    var rowContentView: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            Text(employee.firstName + " " + employee.lastName)
                .font(.system(size: 18, weight: .bold))

            if employee.jobs.isEmpty {
                Text(LocalizedStringKey("No selected jobs."))
                    .font(.system(size: 14))
                    .foregroundStyle(Color.gray)
            } else {
                HStack(
                    spacing: 0
                ) {
                    ForEach(
                        employee.jobs.indices,
                        id: \.self
                    ) { index in
                        Text(employee.jobs[index].name)
                        
                        if employee.jobs.count - 2 > index {
                            Text(", ")
                        } else if employee.jobs.count - 2 == index {
                            Text(LocalizedStringKey(" and "))
                        } else if employee.jobs.count - 1 == index {
                            Text(".")
                        }
                    }
                }
                .font(.system(size: 12))
                .foregroundStyle(Color.gray)
                .lineLimit(1)
                .truncationMode(.tail)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .fontDesign(.rounded)
    }
}

#Preview {
    EmployeeCellView(
        employee: Employee(
            id: "",
            username: "",
            firstName: "",
            lastName: "",
            jobs: []
        )
    )
}
