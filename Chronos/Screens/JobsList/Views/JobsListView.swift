//
//  JobsListView.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import SwiftUI

struct JobsListView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var jobs: [Job] = []
    @State var isLoading = false
    @State var isSubmitting = false
    @State var showSheet = false
    @State var selectedIndex: Int? = nil

    var body: some View {
        contentView
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.theme)
                            .bold()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {

                if !isLoading {
                    VStack(spacing: 0) {
                        HStack {
                            Spacer()
                            FloatingActionButton
                        }

                        MainButton(
                            isLoading: $isSubmitting,
                            isEnable: .constant(true),
                            buttonText: "Save",
                            backgroundColor: .theme) {
                                save()
                            }
                            .padding()
                    }
                }
            }
            .onAppear {
                fetchJobs()
            }
    }

    @ViewBuilder
    private var contentView: some View {
        if isLoading {
            ProgressView()
        } else {
            if jobs.isEmpty {
                Text("No Jobs")
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            } else {
                List {
                    ForEach(jobs.indices, id: \.self) { index in
                        Text(jobs[index].name)
                            .padding()
                            .onTapGesture {
                                self.selectedIndex = index
                                DispatchQueue.main.async {
                                    self.showSheet = true
                                }
                            }
                    }
                    .onDelete(perform: delete)
                }
                .sheet(isPresented: $showSheet) {
                    AddJobView(jobs: $jobs, selectedIndex: selectedIndex)
                }
            }
        }
    }

    @ViewBuilder
    private var FloatingActionButton: some View {
        Button(action: {
            selectedIndex = nil

            DispatchQueue.main.async {
                self.showSheet = true
            }
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

    private func delete(at offsets: IndexSet) {
        jobs.remove(atOffsets: offsets)
    }

    private func fetchJobs() {
        isLoading = true
        Task {
            do {
                let response = try await JobsClient.getJobs()
                jobs = response.jobs
            } catch {
                print(error)
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }

    private func save() {
        isSubmitting = true
        Task {
            do {
                let response = try await JobsClient.updateJob(jobs: jobs)
                print(response)
            } catch {
                print(error)
            }
            await MainActor.run {
                dismiss()
            }
        }
    }
}

#Preview {
    JobsListView()
}
