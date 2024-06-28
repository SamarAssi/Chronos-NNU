//
//  EmployeeJobsListView.swift
//  Chronos
//
//  Created by Samar Assi on 26/06/2024.
//

import SwiftUI

struct EmployeeJobsListView: View {
    @ObservedObject var employeeListModel: EmployeeListModel
    @Environment(\.dismiss) var dismiss

    @Binding var selectedJobs: [Job]
    @Binding var oldSelectedJobs: [Job]

    var jobs: [Job]
    var id: String

    var body: some View {
        NavigationStack {
            List(
                jobs,
                id: \.self
            ) { job in
                ListCellView(
                    isSelected: isSelectedItem(job: job),
                    name: job.label
                )
                .onTapGesture {
                    toggleSelection(job: job)
                }
            }
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    cancelButtonView
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    saveButtonView
                }
            }
            .onAppear {
               // selectedJobs = oldSelectedJobs
            }
        }
    }
    
    var saveButtonView: some View {
        Button {
            addJob()
            dismiss.callAsFunction()
        } label: {
            Text(LocalizedStringKey("Save"))
                .foregroundStyle(selectedJobs.isEmpty ? Color.gray : Color.theme)
        }
        .disabled(selectedJobs.isEmpty)
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                selectedJobs.removeAll()
                dismiss.callAsFunction()
            }
    }
    
    private func isSelectedItem(job: Job) -> Binding<Bool> {
        return Binding(
            get: {
                selectedJobs.contains(job)
            },
            set: { isSelected in
                if isSelected {
                    selectedJobs.append(job)
                } else {
                    selectedJobs.removeAll {
                        $0 == job
                    }
                }
            }
        )
    }
    
    private func toggleSelection(job: Job) {
        if let index = selectedJobs.firstIndex(of: job) {
            selectedJobs.remove(at: index)
        } else {
            selectedJobs.append(job)
        }
    }
    
    private func addJob() {
        if jobs.count == oldSelectedJobs.count { return }
        for oldSelectedJob in oldSelectedJobs {
            if !selectedJobs.contains(oldSelectedJob) {
                selectedJobs.append(oldSelectedJob)
            }
        }
        
        employeeListModel.updateEmployeeJob(
            employeeId: id,
            jobs: selectedJobs
        )
    }
}

#Preview {
    EmployeeJobsListView(
        employeeListModel: EmployeeListModel(),
        selectedJobs: .constant([]),
        oldSelectedJobs: .constant([]),
        jobs: [],
        id: ""
    )
}
