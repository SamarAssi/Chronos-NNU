//
//  EmployeeDetailsView.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import SwiftUI

struct EmployeeDetailsView: View {
    
    @ObservedObject var employeeListModel: EmployeeListModel
    @Environment(\.dismiss) var dismiss
    
    @State private var isAdding = false
    @State private var selectedJobs: [Job] = []
    @State private var newJobs: [Job] = []
    @State private var oldJobs: [Job]?
    
    var employee: Employee
    
    var isAddJobButtonDisabled: Bool {
        return selectedJobs.isEmpty
    }
    
    var addJobButtonColor: Color {
        isAddJobButtonDisabled ?
        Color.theme.opacity(0.5) :
        Color.theme
    }
    
    var isAddButtonToolbarDisabled: Bool {
        for job in employeeListModel.jobs {
            if let oldJobs = oldJobs {
                if !oldJobs.contains(job) {
                    return false
                }
            }
        }
        return true
    }
    
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 15
            ) {
                headerSectionView
                usernameView
                if let oldJobs = oldJobs {
                    if !oldJobs.isEmpty {
                        jobsListView
                        
                        if isAdding {
                            jobAdditionView
                        }
                    } else {
                        if isAdding {
                            jobAdditionView
                        } else {
                            
                            VStack(
                                spacing: 8
                            ) {
                                Text(LocalizedStringKey("No selected jobs until now"))
                                    .font(.subheadline)
                                
                                Image(systemName: "exclamationmark.questionmark")
                                    .font(.largeTitle)
                            }
                            .foregroundStyle(Color.gray)
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .center
                            )
                        }
                    }
                }
            }
            .fontDesign(.rounded)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButtonView
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        deleteEmployeeButtonView
                        addJobButtonView
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .onAppear {
                employeeListModel.getJobsList()
                oldJobs = employee.jobs
            }
            .onDisappear {
                employeeListModel.getEmployeesList()
            }
            .onChange(of: oldJobs) {
                oldJobs = employee.jobs
            }
        }
    }
}

extension EmployeeDetailsView {
    
    var deleteEmployeeButtonView: some View {
        Button {
            deleteEmployee()
            dismiss.callAsFunction()
        } label: {
            Text(LocalizedStringKey("Delete"))
            Image(systemName: "trash")
        }
    }
    
    var addJobButtonView: some View {
        Button {
            isAdding.toggle()
        } label: {
            Text(LocalizedStringKey("Add new Job"))
            Image(systemName: "plus")
        }
        .disabled(isAddButtonToolbarDisabled)
    }
    
    var jobAdditionView: some View {
        VStack {
            HStack {
                if let jobsResponse = employeeListModel.jobsResponse {
                    ScrollableListView(
                        selectedItems: $selectedJobs,
                        label: "Select the job/s:",
                        items: newJobs,
                        withIcon: true
                    )
                    .onAppear {
                        newJobs.removeAll()
                        isCheck(jobsResponse: jobsResponse)
                    }
                }
            }
            
            HStack {
                Button {
                    addJob()
                    isAdding = false
                } label: {
                    Text(LocalizedStringKey("Add"))
                }
                .foregroundStyle(addJobButtonColor)
                .disabled(isAddJobButtonDisabled)
                
                Button {
                    isAdding.toggle()
                } label: {
                    Text(LocalizedStringKey("Cancel"))
                }
                .foregroundStyle(Color.gray)
            }
            .padding(.horizontal, 10)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
        }
        .font(.subheadline)
        .padding(.horizontal)
    }
    
    var headerSectionView: some View {
        ZStack {
            Color.theme
                .ignoresSafeArea()
            
            VStack(
                spacing: 20
            ) {
                imageView
                fullNameView
                Spacer()
            }
            .foregroundStyle(Color.white)
        }
        .frame(height: UIScreen.main.bounds.height / 5)
    }
    
    var imageView: some View {
        Image(.logo)
            .resizable()
            .scaledToFit()
            .frame(height: 100)
            .background(
                Circle()
                    .fill(Color.white)
                    .shadow(color: .white, radius: 10)
            )
    }
    
    var fullNameView: some View {
        Text(employee.firstName + " " + employee.lastName)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var usernameView: some View {
        HStack {
            Image(systemName: "person")
            Text(employee.username)
        }
        .padding(.horizontal)
    }
    
    var phoneNumberView: some View {
        HStack {
            Image(systemName: "phone")
            
        }
        .padding(.horizontal)
    }
    
    var jobsListView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Jobs"))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
                .padding(.horizontal)
            
            
            List {
                if let oldJobs = oldJobs {
                    ForEach(
                        oldJobs,
                        id: \.self
                    ) { job in
                        Text("• \(job.name).")
                            .listRowSeparator(.hidden)
                            .padding(.horizontal)
                    }
                    .onDelete { indexSet in
                        deleteJob(
                            at: indexSet,
                            from: employee.jobs
                        )
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .foregroundStyle(Color.white)
            .scaleEffect(0.8)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
}

extension EmployeeDetailsView {
    
    private func deleteJob(
        at indices: IndexSet,
        from jobs: [Job]
    ) {
        var newJobs = jobs
        
        indices.forEach { index in
            newJobs.remove(at: index)
            employeeListModel.updateEmployeeJob(
                employeeId: employee.id,
                jobs: newJobs
            )
            
            oldJobs = newJobs
        }
    }
    
    private func deleteEmployee() {
        employeeListModel.deleteEmployee(username: employee.username)
    }
    
    private func addJob() {
        var newJobs = employee.jobs
        
        newJobs.append(contentsOf: selectedJobs)
        employeeListModel.updateEmployeeJob(
            employeeId: employee.id,
            jobs: newJobs
        )
        oldJobs = newJobs
    }
    
    private func isCheck(jobsResponse: JobsResponse) {
        guard let oldJobs = oldJobs else { return }
        let employeeJobsNames = oldJobs.compactMap { $0.name }
        let managerJobsNames = jobsResponse.jobs.compactMap { $0.name }
        
        for index in managerJobsNames.indices {
            if !employeeJobsNames.contains(managerJobsNames[index]) {
                newJobs.append(jobsResponse.jobs[index])
            }
        }
    }
}


#Preview {
    EmployeeDetailsView(
        employeeListModel: EmployeeListModel(),
        employee: Employee(
            id: "",
            username: "samarassi",
            firstName: "Samar",
            lastName: "Assi",
            jobs: []
        )
    )
}
