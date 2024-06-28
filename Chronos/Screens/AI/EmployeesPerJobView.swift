//
//  EmployeesPerJobView.swift
//  Chronos
//
//  Created by Bassam Hillo on 28/06/2024.
//

import SwiftUI

struct EmployeesPerJobView: View {

    @Binding var jobs: [JobChoice]

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

                Text("Select employees")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .listRowSeparator(.hidden)

                ForEach($jobs) { $jobChoice in
                    if jobChoice.isSelected {
                        HStack {
                            Text(jobChoice.job.name)
                            Spacer()
                            NumberInputView(number: $jobChoice.numberOfEmployees)
                                .multilineTextAlignment(.trailing)
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
        )
    )
}

// Subview using Binding
struct NumberInputView: View {
    @Binding var number: Int?

    var body: some View {
        TextField("Employee Count", text: Binding<String>(
            get: {
                // When the number is nil, display an empty string
                self.number.map(String.init) ?? ""
            },
            set: {
                // Convert the input string back to an Int?
                self.number = Int($0)
            }
        ))
    }
}
