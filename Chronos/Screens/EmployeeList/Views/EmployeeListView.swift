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
    
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading
            ) {
                if employeeListModel.isLoading {
                    CustomProgressView()
                } else {
                    if let employeesResponse = employeeListModel.employeesResponse {
                        if employeesResponse.employees.isEmpty {
                            emptyView
                        } else {
                            List(
                                employeesResponse.employees,
                                id: \.self
                            ) { employee in
                                EmployeeCellView(
                                    fullName: employee.firstName + " " + employee.lastName,
                                    jobs: employee.jobs
                                )
                            }
                        }
                    }
                    
                    tabView
                        .padding(.horizontal)
                }
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
            .fullScreenCover(isPresented: $isShowAddEmployeeView) {
                AddEmployeeView()
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
            .padding(.top, 25)
    }

    var emptyView: some View {
        VStack {
            Image(.SAMAR_911)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text("Oops, No employees until now")
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
        Group {
            if ((employeeListModel.employeesResponse?.employees.isEmpty) == nil) {
                Button {
                    isEditing.toggle()
                } label: {
                    Text(isEditing ? "Edit" : "Done")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
            }
        }
    }

    var tabView: some View {
        HStack {
            if !isEditing {
                Image(systemName: "trash")
            }
            Image(systemName: "plus")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    isShowAddEmployeeView.toggle()
                }
        }
        .frame(height: 30)
    }
}

#Preview {
    EmployeeListView()
}
