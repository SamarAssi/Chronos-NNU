//
//  ScheduledSettings.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI

struct ScheduledSettings: View {

    @Environment(\.dismiss) var dismiss
    @State var jobs: [Job] = []
    @State var isSubmitting = false
    @State var isLoading = false

    var body: some View {
        NavigationView {
            loadingOrContentViews
                .navigationTitle("Scheduled Settings")
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
        }
        .onAppear {
            fetchJobs()
        }
    }

    @ViewBuilder
    private var loadingOrContentViews: some View {
        if isLoading {
            ProgressView()
        } else {
            contentViews
        }
    }

    @ViewBuilder
    private var contentViews: some View {
        List($jobs) { job in
            JobSettingsSection(job: job)
        }
        .safeAreaInset(edge: .bottom) {
            MainButton(
                isLoading: $isSubmitting,
                isEnable: .constant(true),
                buttonText: "Save",
                backgroundColor: .theme) {
                    saveJobs()
                }
                .padding()
        }
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

    private func saveJobs() {
        isSubmitting = true
        Task {
            do {
                let response = try await JobsClient.updateJob(jobs: jobs)
                print(response)
            } catch {
                print(error)
            }
            await MainActor.run {
                isSubmitting = false
                dismiss()
            }
        }
    }
}

#Preview {
    ScheduledSettings()
}
