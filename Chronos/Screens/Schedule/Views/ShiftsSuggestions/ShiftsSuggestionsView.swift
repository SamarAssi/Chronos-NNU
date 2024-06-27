//
//  ShiftsSuggestionsView.swift
//  Chronos
//
//  Created by Bassam Hillo on 24/06/2024.
//

import SwiftUI
import SimpleToast


struct ShiftsSuggestionsView: View {

    @State private var selectedStep = 0
    let questions = [
        "Jobs to be scheduled",
        "Who needs to be scheduled",
        "How how many employees for each job",
        "extra information"
    ]

    // State to track the selected choices
    @State private var jobs: [JobChoice] = []
    @State private var employees: [EmployeeChoice] = []
    @State private var description: String = ""

    var selectedJobs: [JobChoice] {
        jobs.filter { $0.isSelected }
    }

    var body: some View {
        VStack {
            questionsTabView
            Spacer()
            HStack {
                if selectedStep > 0 {
                    Button("Previous") {
                        withAnimation {
                            selectedStep = selectedStep - 1
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .foregroundStyle(Color.white)
                    .background(.theme)
                    .clipShape(Capsule())
                }

                Spacer()

                Button(selectedStep == questions.count - 1 ? "Submit" : "Next") {
                    withAnimation {
                        if selectedStep == questions.count - 1 {
                            // Submit
                        } else {
                            selectedStep = selectedStep + 1
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .foregroundStyle(Color.white)
                .background(.theme)
                .clipShape(Capsule())
            }
            .padding()
        }
        .onAppear {
            Task {
                do {
                    async let jobs = JobsClient.getJobs()
                    async let employees = try EmployeesClient.getEmployees()

                    let (jobsResponse, employeesResponse) = try await (jobs, employees)

                    self.jobs = jobsResponse.jobs.map {
                        JobChoice(
                            job: $0,
                            isSelected: false
                        )
                    }
                    self.employees = employeesResponse.employees.map {
                        EmployeeChoice(
                            employee: $0,
                            isSelected: false
                        )
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    private var questionsTabView: some View {
        VStack {
            TabView(selection: $selectedStep) {
                ForEach(
                    questions.indices,
                    id: \.self
                ) { index in
                    List {
                        Text(questions[index])
                            .font(.title)
                            .padding()

                        getQuestionView(number: index)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }

    @ViewBuilder
    private func getQuestionView(number: Int) -> some View {
        switch number {
        case 0 : jobsView
        case 1: employeesView
        case 2: employeesPerJobView
        case 3: extraInformationView
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var jobsView: some View {
        ForEach($jobs) { $choice in
            Toggle(isOn: $choice.isSelected) {
                Text(choice.job.name)
            }
        }
    }
    
    @ViewBuilder
    private var employeesView: some View {
        ForEach($employees) { $choice in
            Toggle(isOn: $choice.isSelected) {
                Text(choice.employee.firstName + " " + choice.employee.lastName)
            }
        }
    }
    
    @ViewBuilder
    private var employeesPerJobView: some View {
        ForEach(selectedJobs) { jobChoice in
            HStack {
                Text(jobChoice.job.name)
                Spacer()
                TextField(
                    "Count",
                    value: .constant(""),
                    formatter: NumberFormatter()
                )
            }
        }
        .background(.red)
    }

    @ViewBuilder
    private var extraInformationView: some View {
        TextEditor(text: $description)
            .font(.system(size: 15))
            .textInputAutocapitalization(.never)
            .tint(Color.theme)
            .scrollContentBackground(.hidden)
            .padding(8)
            .frame(height: 300)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    struct JobChoice: Identifiable {
        var id = UUID()
        var job: Job
        var isSelected: Bool
        var numberOfEmployees: Int = 0
    }

    struct EmployeeChoice: Identifiable {
        var id = UUID()
        var employee: Employee
        var isSelected: Bool
    }
}

#Preview {
    ShiftsSuggestionsView()
}
