//
//  EmployeeListView.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import SwiftUI

struct EmployeeListView: View {
    
    @StateObject private var employeeListModel = EmployeeListModel()
    
    @State private var isShowAddEmployeeView = false
    @State private var selectedEmployee: Employee?
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            titleView

            Divider()
                .padding(.top)

            if employeeListModel.isLoading {
                CustomProgressView()
            } else {
                if let employeesResponse = employeeListModel.employeesResponse {
                    if employeesResponse.employees.isEmpty {
                        emptyView
                    } else {
                        employeeListView(employeesResponse: employeesResponse)
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .fullScreenCover(item: $selectedEmployee) { employee in
            EmployeeDetailsView(
                employeeListModel: employeeListModel,
                employee: employee
            )
        }
        .fullScreenCover(isPresented: $isShowAddEmployeeView) {
            AddEmployeeView(employeeListModel: employeeListModel)
        }
        .safeAreaInset(edge: .bottom) {
            FloatingActionButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        .onAppear {
            employeeListModel.getEmployeesList()
        }
    }
}

extension EmployeeListView {
    
    private var FloatingActionButton: some View {
        Button(action: {
            isShowAddEmployeeView.toggle()
        }) {
            Circle()
                .foregroundColor(.theme)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(.white)
                        .padding(14)
                )
                .padding()
        }
    }
    
    var titleView: some View {
        Text(LocalizedStringKey("Employees List"))
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal, 18)
            .padding(.top)
    }
    
    var emptyView: some View {
        VStack {
            Image(.SAMAR_911)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            Text(LocalizedStringKey("Oops, No employees until now"))
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
    }
}

extension EmployeeListView {
    
    private func employeeListView(
        employeesResponse: EmployeesResponse
    ) -> some View {
        List {
            ForEach(
                employeesResponse.employees,
                id: \.self
            ) { employee in
                EmployeeCellView(
                    employee: employee
                )
                .onTapGesture {
                    selectedEmployee = employee
                }
            }
            .onDelete { indexSet in
                deleteEmployees(
                    at: indexSet,
                    from: employeesResponse.employees
                )
            }
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
    
    private func deleteEmployees(
        at offsets: IndexSet,
        from employees: [Employee]
    ) {
        offsets.forEach { index in
            let employee = employees[index]
            employeeListModel.deleteEmployee(username: employee.username)
        }
    }
}

#Preview {
    EmployeeListView()
}
