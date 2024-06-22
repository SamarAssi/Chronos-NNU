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
        
    var isDeleteButtonDisabled: Bool {
        return selectedJobs.isEmpty
    }
    
    var deleteButtonColor: Color {
        selectedJobs.isEmpty ?
        Color.red.opacity(0.5) :
        Color.red
    }

    var body: some View {
        ZStack(
            alignment: .bottom
        ) {
            if jobsListModel.isLoading {
                CustomProgressView()
            } else {
                if let jobsResponse = jobsListModel.jobsResponse {
                    if jobsResponse.jobs.isEmpty {
                        emptyView
                    } else {
                        List {
                            ForEach(
                                jobsResponse.jobs,
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
                                    from: jobsResponse.jobs
                                )
                            }
                        }
                        .listStyle(PlainListStyle())
                        .scrollIndicators(.hidden)
                    }
                }

                if !isEditing {
                    tabView
                }
            }
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
                editButtonView
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

    var titleView: some View {
        Text(LocalizedStringKey("Jobs List"))
            .font(.title2)
            .fontWeight(.bold)
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
                            deleteButtonView
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
            isShowAddJobView.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundStyle(Color.black)
        }
    }
    
    var deleteButtonView: some View {
        Button {
            if let responseJob = jobsListModel.jobsResponse {
                deleteMultipleJobs(from: responseJob.jobs)
            }
            isEditing = true
        } label: {
            Image(systemName: "trash")
                .font(.title2)
                .foregroundStyle(deleteButtonColor)
        }
        .disabled(isDeleteButtonDisabled)
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
