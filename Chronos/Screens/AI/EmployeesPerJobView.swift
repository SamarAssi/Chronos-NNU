//
//  EmployeesPerJobView.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI

struct EmployeesPerJobView: View {

    @Binding var jobs: [JobChoice]
    let question: String

    var body: some View {
        List {
            Image("countAvatar")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .listRowSeparator(.hidden)

            if jobs.filter({ $0.isSelected }).isEmpty {
                Text("Please select jobs first")
                    .foregroundColor(.red)
            } else {

                Text(question)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .listRowSeparator(.hidden)

                ForEach($jobs) { $jobChoice in
                    if jobChoice.isSelected {
                        HStack {
                            Text(jobChoice.job.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()

                            HStack {
                                NumberInputView(
                                    title: "Min",
                                    number: $jobChoice.minNumberOfEmployees
                                )
                                .multilineTextAlignment(.trailing)
                                NumberInputView(
                                    title: "Max",
                                    number: $jobChoice.maxNumberOfEmployees
                                )
                                .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
            }
        }

    }
}

#Preview {
    EmployeesPerJobView(
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
                    isSelected: true
                ),
                JobChoice(
                    job: Job(
                        id: "3",
                        name: "Job 3"
                    ),
                    isSelected: false
                )
            ]
        ), question: "How many employees do you need for each job?"
    )
}

// Subview using Binding
struct NumberInputView: View {
    let title: String
    @Binding var number: Int?

    var body: some View {
        TextField(title, text: Binding<String>(
            get: {
                // When the number is nil, display an empty string
                self.number.map(String.init) ?? ""
            },
            set: {
                // Convert the input string back to an Int?
                self.number = Int($0)
            }
        ))
        .padding(5)
        .padding(.bottom, 7)
    }
}
