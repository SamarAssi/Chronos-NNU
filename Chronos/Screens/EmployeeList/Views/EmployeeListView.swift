//
//  EmployeeListView.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import SwiftUI

struct EmployeeListView: View {

    @StateObject private var employeeListModel = EmployeeListModel()

    @State private var isEditing = true
    @State private var isShowAddEmployeeView = false
    @State private var selectedEmployee: Employee?
    
    @Binding var isShowCurrentTabView: Bool
    
    var body: some View {
        NavigationStack {
            ZStack(
                alignment: .bottom
            ) {
                if employeeListModel.isLoading {
                    CustomProgressView()
                } else {
                    if let employeesResponse = employeeListModel.employeesResponse {
                        if employeesResponse.employees.isEmpty {
                            emptyView
                                .offset(y: isEditing ? 0 : -24.2)
                        } else {
                            employeeListView(employeesResponse: employeesResponse)
                        }
                    }
                    
                    if !isEditing {
                        tabView
                    }
                }
            }
            .onChange(of: isEditing) {
                isShowCurrentTabView.toggle()
            }
            .fontDesign(.rounded)
            .onAppear {
                employeeListModel.getEmployeesList()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    titleView
                }
                ToolbarItem(placement: .topBarTrailing) {
                    editButtonView
                }
            }
            .fullScreenCover(item: $selectedEmployee) { employee in
                EmployeeDetailsView(
                    employeeListModel: employeeListModel,
                    employee: employee
                )
            }
            .fullScreenCover(isPresented: $isShowAddEmployeeView) {
                AddEmployeeView(employeeListModel: employeeListModel)
            }
        }
    }
}

extension EmployeeListView {
    var titleView: some View {
        Text(LocalizedStringKey("Employees List"))
            .font(.title2)
            .fontDesign(.rounded)
            .fontWeight(.bold)
            .padding(.horizontal, 5)
            .padding(.vertical, 25)
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
    
    var editButtonView: some View {
        Button {
            isEditing.toggle()
        } label: {
            Text(isEditing ? "Edit" : "Done")
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(Color.black)
                .padding(.vertical, 25)
        }
    }

    var tabView: some View {
        VStack(
            spacing: 0
        ) {
            Divider()
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea(edges: [.horizontal, .bottom])
                .frame(height: 49)
                .overlay {
                    HStack {
                        if !isEditing {
                            addButtonView
                        }
                    }
                    .padding()
                    .padding(.horizontal, 5)
                    .padding(.bottom)
                }
        }
    }
    
    var addButtonView: some View {
        Button {
            isShowAddEmployeeView.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(Color.black)
        }
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
                    if isEditing {
                        selectedEmployee = employee
                    }
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
        employeeListModel.getEmployeesList()
    }
}

#Preview {
    EmployeeListView(isShowCurrentTabView: .constant(false))
}
