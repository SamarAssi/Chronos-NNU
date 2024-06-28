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
    @State private var isShowAlert = false
    @State private var isShowJobsList = false
    @State private var selectedJobs: [Job] = []
    @State private var oldSelectedJobs: [Job] = []

    var employee: Employee

    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 0
            ) {
                headerSectionView
                usernameView
                    .padding(.vertical)
                Divider()

                if !employeeListModel.jobs.isEmpty {
                    jobsListView
                } else {
                    emptyView
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
                        editButtonView
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .onAppear {
                employeeListModel.getJobsList()
                employeeListModel.getEmployeeDetails(employeeId: employee.id)
            }
            .alert(
                LocalizedStringKey("Are you sure you want to remove this employee?"),
                isPresented: $isShowAlert
            ) {
                alertButtonsView
            }
            .fullScreenCover(isPresented: $isShowJobsList) {
                if let jobsResponse = employeeListModel.jobsResponse {
                    EmployeeJobsListView(
                        employeeListModel: employeeListModel,
                        selectedJobs: $selectedJobs,
                        oldSelectedJobs: $oldSelectedJobs,
                        jobs: jobsResponse.jobs,
                        id: employee.id
                    )
                }
            }
        }
    }
    
    var alertButtonsView: some View {
        HStack {
            Button("Cancel", role: .cancel) {
                isShowAlert = false
            }
            Button("Remove", role: .destructive) {
                deleteEmployee()
                dismiss.callAsFunction()
            }
        }
    }
}

extension EmployeeDetailsView {
    
    var emptyView: some View {
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
    
    var deleteEmployeeButtonView: some View {
        Button {
            isShowAlert.toggle()
        } label: {
            Text(LocalizedStringKey("Remove employee"))
            Image(systemName: "trash")
        }
    }
    
    var editButtonView: some View {
        Button {
            if let jobsResponse = employeeListModel.jobsResponse {
                identifyNewJobsNotInEmployeeList(from: jobsResponse)
            }
            isShowJobsList.toggle()
        } label: {
            Text(LocalizedStringKey("Edit Jobs"))
            Image(systemName: "square.and.pencil")
        }
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
    
    var jobsListView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {

            if employeeListModel.isLoadingJobs {
                CustomProgressView()
            } else {
                List {
                    Section("Jobs") {
                        ForEach(
                            employeeListModel.jobs,
                            id: \.self
                        ) { job in
                            Text(job.name)
                        }
                        .onDelete { indexSet in
                            deleteJob(
                                at: indexSet,
                                from: employeeListModel.jobs
                            )
                        }
                    }
                }
            }
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
        }
    }
    
    private func deleteEmployee() {
        employeeListModel.deleteEmployee(username: employee.username)
    }
    
    private func identifyNewJobsNotInEmployeeList(
        from jobsResponse: JobsResponse
    ) {
        let employeeJobsNames = employeeListModel.jobs.compactMap { $0.name }
        let managerJobsNames = jobsResponse.jobs.compactMap { $0.name }
        
        for index in employeeJobsNames.indices {
            if managerJobsNames.contains(employeeJobsNames[index]) {
                if let managerJobIndex = managerJobsNames.firstIndex(of: employeeJobsNames[index]) {
                    oldSelectedJobs.append(jobsResponse.jobs[managerJobIndex])
                }
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
