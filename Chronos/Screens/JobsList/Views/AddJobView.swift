//
//  AddJobView.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import SwiftUI
import SimpleToast

struct AddJobView: View {
    
    @ObservedObject var jobsListModel: JobsListModel
    
    @State private var textField: TextFieldModel = TextFieldModel.addJobData
    @State private var jobsNames: [String] = []
    @State private var isShowToast = false
    
    @Binding var isEditing: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var selectedJob: Job?
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )
    
    var titleText: LocalizedStringKey {
        selectedJob == nil ?
        "Add Job" :
        "Update Job"
    }
    
    var saveButtonText: LocalizedStringKey {
        selectedJob == nil ?
        "save" :
        "Update"
    }
    
    var isAddButtonDisabled: Bool {
        return isEmptyField()
    }
    
    var isSaveButtonDisabled: Bool {
        selectedJob == nil ?
        jobsNames.isEmpty :
        isEmptyField()
    }
    
    var addButtonBackgroundColor: Color {
        isEmptyField() ?
        Color.red.opacity(0.5) :
        Color.red
    }
    
    var saveButtonBackgroundColor: Color {
        isSaveButtonDisabled ?
        Color.theme.opacity(0.5) :
        Color.theme
    }
    
    var body: some View {
        NavigationStack {
            VStack(
                alignment: .leading,
                spacing: 20
            ) {
                TextFieldView(textFieldModel: textField)
                    .padding()
                
                if selectedJob == nil {
                    if !jobsNames.isEmpty {
                        Text(LocalizedStringKey("Added jobs:"))
                            .font(.system(size: 15))
                            .fontWeight(.bold)
                            .padding(.leading)
                    }
                }
                jobsNamesList
                HStack {
                    if selectedJob == nil {
                        addButtonView
                    }
                    saveButtonView
                }
                .padding()
            }
            .fontDesign(.rounded)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButtonView
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    titleView
                }
            }
        }
        .simpleToast(
            isPresented: $isShowToast,
            options: toastOptions
        ) {
            ToastView(type: .info, message: "The job already exists!")
                .padding(.horizontal)
        }
        .onAppear {
            if selectedJob != nil {
                textField.text = selectedJob?.name ?? ""
            }
        }
        .onDisappear {
            //jobsListModel.getJobsList()
            isEditing = true
        }
    }
}

extension AddJobView {
    
    var titleView: some View {
        Text(titleText)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var addButtonView: some View {
        MainButton(
            isLoading: .constant(false),
            isEnable: .constant(true),
            buttonText: "Add",
            backgroundColor: addButtonBackgroundColor,
            action: {
                if !jobsNames.contains(textField.text) {
                    jobsNames.append(textField.text)
                } else {
                    isShowToast = true
                }
                textField.text = ""
            }
        )
        .disabled(isAddButtonDisabled)
    }
    
    var saveButtonView: some View {
        MainButton(
            isLoading: $jobsListModel.isLoading,
            isEnable: .constant(true),
            buttonText: saveButtonText,
            backgroundColor: saveButtonBackgroundColor,
            action: {
                if selectedJob == nil {
                    addJob()
                } else {
                    updateJob()
                }
                dismiss.callAsFunction()
            }
        )
        .disabled(isSaveButtonDisabled)
    }
    
    var jobsNamesList: some View {
        List {
            ForEach(
                jobsNames,
                id: \.self
            ) { jobName in
                Text("• \(jobName)")
                    .listRowSeparator(.hidden)
                    .padding(.horizontal)
            }
            .onDelete(perform: deleteJob)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
}

extension AddJobView {
    
    private func addJob() {
        var jobs = jobsNames.compactMap { 
            Job(
                id: nil,
                name: $0,
                sundaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                mondaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                tuesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                wednesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                thursdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                fridaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                saturdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1)
            )
        }
        
        for job in jobsListModel.jobs {
            if jobsNames.contains(job.name) {
                if let index = jobsListModel.jobs.firstIndex(of: job) {
                    jobsListModel.jobs.remove(at: index)
                }
            }
        }
        
        jobs.append(contentsOf: jobsListModel.jobs)
        
        jobsListModel.handleUpdateJobResponse(jobs: jobs)
    }
    
    private func updateJob() {
        var names = jobsListModel.jobs.compactMap { $0.name }
        
        for name in names {
            if let selectedJob = selectedJob {
                if name == selectedJob.name {
                    if let index = names.firstIndex(of: selectedJob.name) {
                        names[index] = textField.text
                    }
                }
            }
        }
        
        let newJobs = names.compactMap {
            Job(
                id: nil,
                name: $0,
                sundaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                mondaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                tuesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                wednesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                thursdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                fridaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                saturdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1)
            )
        }
        
        jobsListModel.handleUpdateJobResponse(jobs: newJobs)
    }
    
    private func isEmptyField() -> Bool {
        return textField.text.isEmpty
    }
    
    private func deleteJob(at indices: IndexSet) {
        indices.forEach { index in
            jobsNames.remove(at: index)
        }
    }
}

#Preview {
    AddJobView(
        jobsListModel: JobsListModel(),
        isEditing: .constant(false),
        selectedJob: nil
    )
}
