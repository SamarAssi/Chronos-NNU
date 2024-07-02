//
//  EmployeesReportView.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI
import Alamofire

struct EmployeesReportView: View {

    @Environment(\.openURL) var openURL
    @State var employees: [Employee] = []
    @State var selectedEmployee: Employee = Employee(
        id: "",
        username: "",
        firstName: "",
        lastName: "",
        jobs: []
    )

    @State var startDate = Date()
    @State var endDate = Date()

    @State var isLoading = false

    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .theme))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .animation(.easeInOut, value: isLoading)
                    .navigationTitle("Employees Report")

            } else {
                contentView
                    .navigationTitle("Employees Report")
                    .safeAreaInset(edge: .bottom) {
                        MainButton(
                            isLoading: $isLoading,
                            isEnable: .constant(true),
                            buttonText: "Generate Report",
                            backgroundColor: .theme) {
                                openURL(URL(string: "https://timeshift-420211.ew.r.appspot.com/statistics/\(selectedEmployee.id)/\(startDate.toString())/\(endDate.toString())")!)
                            }
                            .padding()
                    }

            }
        }
        .onAppear {
            isLoading = true
            Task {
                do {
                    let response = try await EmployeesClient.getEmployees(includeAll: true)
                    employees = response.employees
                    if let firstEmployee = employees.first {
                        selectedEmployee = firstEmployee
                    }
                } catch {
                    print(error)
                }

                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }

    private var contentView: some View {
        List {
            Picker(
                "Employee",
                selection: $selectedEmployee
            ) {
                ForEach(employees, id:\.self) { employee in
                    Text(employee.firstName + " " + employee.lastName)
                }
            }
            .pickerStyle(.automatic)
            .padding(.vertical, 7)

            DatePicker(
                "Start Date",
                selection: $startDate,
                displayedComponents: [.date]
            )
            DatePicker(
                "End Date",
                selection: $endDate,
                displayedComponents: [.date]
            )
        }
    }
}

#Preview {
    EmployeesReportView()
}
