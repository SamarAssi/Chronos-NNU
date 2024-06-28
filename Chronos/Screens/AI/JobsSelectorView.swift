//
//  JobsSelectorView.swift
//  Chronos
//
//  Created by Bassam Hillo on 28/06/2024.
//

import SwiftUI

struct JobChoice: Identifiable, Equatable {
    var id = UUID()
    var job: Job
    var isSelected: Bool
    var numberOfEmployees: Int? = nil
}

struct JobsSelectorView: View {

    @Binding var jobs: [JobChoice]
    let question: String

    var body: some View {
        List {

            Image("jobAvatar")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 10)


            Text(question)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .listRowSeparator(.hidden)

            ForEach($jobs) { $choice in
                CheckBox(
                    value: $choice.isSelected,
                    label: choice.job.name
                )
            }
        }
    }
}

#Preview {
    JobsSelectorView(
        jobs: .constant(
            [
                JobChoice(
                    job: Job(
                        id: "1",
                        name: "Job 1"
                    ),
                    isSelected: false
                ),
                JobChoice(
                    job: Job(
                        id: "2",
                        name: "Job 2"
                    ),
                    isSelected: false
                ),
                JobChoice(
                    job: Job(
                        id: "3",
                        name: "Job 3"
                    ),
                    isSelected: false
                )
            ]
        ), question: "Select all jobs"
    )
}

