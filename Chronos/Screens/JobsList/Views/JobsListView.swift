//
//  JobsListView.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import SwiftUI

struct JobsListView: View {
    
    @StateObject private var jobsListModel = JobsListModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = true
    @State private var isShowAddJobView = false
    @State private var selectedJobs: [Job] = []
    @State private var selectedJob: Job?
    
    var body: some View {
        ZStack(
            alignment: .bottom
        ) {
            if jobsListModel.isLoading {
                CustomProgressView()
            } else {
                if jobsListModel.jobs.isEmpty {
                    emptyView
                } else {
                    List {
                        ForEach(
                            jobsListModel.jobs,
                            id: \.self
                        ) { job in
                            JobCellView(
                                isSelected: isSelectedJob(job: job),
                                isEditing: isEditing,
                                jobName: job.name
                            )
                            .onTapGesture {
                                if isEditing {
                                    selectedJob = job
                                } else {
                                    toggleSelection(job: job)
                                }
                            }
                            .onChange(of: isEditing) {
                                updateSelectionStatus()
                            }
                            .onDisappear {
                                jobsListModel.getJobsList()
                            }
                        }
                        .onDelete { indexSet in
                            deleteJob(
                                at: indexSet,
                                from: jobsListModel.jobs
                            )
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollIndicators(.hidden)
                }
            }
            
            FloatingActionButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .fontDesign(.rounded)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButtonView
            }
            
            ToolbarItem(placement: .topBarLeading) {
                titleView
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                if isEditing {
                    editButtonView
                } else {
                    deleteButtonView
                }
            }
        }
        .onAppear {
            jobsListModel.getJobsList()
        }
        .fullScreenCover(item: $selectedJob) { selectedJob in
            AddJobView(
                jobsListModel: jobsListModel,
                isEditing: $isEditing,
                selectedJob: selectedJob
            )
        }
        .fullScreenCover(isPresented: $isShowAddJobView) {
            AddJobView(
                jobsListModel: jobsListModel,
                isEditing: $isEditing
            )
        }
    }
}

extension JobsListView {
    
    private var FloatingActionButton: some View {
        Button(action: {
            isShowAddJobView.toggle()
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
        Text(LocalizedStringKey("Jobs List"))
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var editButtonView: some View {
        Button {
            isEditing.toggle()
        } label: {
            Text(LocalizedStringKey("Edit"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(jobsListModel.jobs.isEmpty ? Color.gray : Color.black)
                .padding(.vertical, 25)
        }
        .disabled(jobsListModel.jobs.isEmpty)
    }
    
    var emptyView: some View {
        VStack {
            Image(.SAMAR_911)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            Text(LocalizedStringKey("Oops, No jobs until now"))
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
    }
    
    var backButtonView: some View {
        Image(systemName: "chevron.left")
            .scaleEffect(0.9)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var deleteButtonView: some View {
        Button {
            if !selectedJobs.isEmpty {
                if let responseJob = jobsListModel.jobsResponse {
                    deleteMultipleJobs(from: responseJob.jobs)
                }
            }
            isEditing = true
        } label: {
            Text(LocalizedStringKey("Delete"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .foregroundStyle(Color.red)
        }
    }
}

extension JobsListView {
    
    private func isSelectedJob(job: Job) -> Binding<Bool> {
        return Binding(
            get: { selectedJobs.contains(job) },
            set: { isSelected in
                if isSelected {
                    selectedJobs.append(job)
                } else {
                    selectedJobs.removeAll(where: { $0 == job })
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
    
    private func updateSelectionStatus() {
        if !isEditing {
            selectedJobs.removeAll()
        }
    }
    
    private func deleteJob(
        at indices: IndexSet,
        from jobs: [Job]
    ) {
        var newJobs = jobs
        
        indices.forEach { index in
            newJobs.remove(at: index)
            jobsListModel.handleUpdateJobResponse(jobs: newJobs)
            jobsListModel.getJobsList()
        }
    }
    
    private func deleteMultipleJobs(from jobs: [Job]) {
        var newJobs = jobs
        
        for selectedJob in selectedJobs {
            if newJobs.contains(selectedJob) {
                if let index = newJobs.firstIndex(of: selectedJob) {
                    newJobs.remove(at: index)
                }
            }
        }
        
        if jobs.isEmpty {
            selectedJobs.removeAll()
        }
        
        jobsListModel.handleUpdateJobResponse(jobs: newJobs)
    }
}

#Preview {
    JobsListView()
}
