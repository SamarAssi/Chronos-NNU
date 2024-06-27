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
    @State private var isLoading = false

    @State var showShiftsView = false
    @State var errorMsg: LocalizedStringKey = ""
    @State var showToast = false
    @State var suggestedShifts: [Shift] = []

    var body: some View {
        NavigationStack {
            ZStack {
                contendView

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .theme))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                        .ignoresSafeArea()
                }
            }
            .navigationTitle("Shifts Suggestions")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showShiftsView) {
                //SuggestedShiftsView(shifts: suggestedShifts)
            }
            .simpleToast(
                isPresented: $showToast,
                options: SimpleToastOptions(
                    alignment: .top,
                    hideAfter: 5,
                    animation: .linear(duration: 0.3),
                    modifierType: .slide,
                    dismissOnTap: true
                )) {
                    ToastView(
                        type: .error,
                        message: errorMsg
                    )
                    .padding(.horizontal, 30)
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
    }

    private var contendView: some View {
        VStack(spacing: 0) {
            Divider()
            questionsTabView
            Spacer()
            HStack {
                if selectedStep > 0 {
                    Button("Previous") {
                        withAnimation {
                            selectedStep = selectedStep - 1
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 7)
                    .foregroundStyle(Color.white)
                    .background(.theme)
                    .clipShape(Capsule())
                }

                Spacer()

                Button(selectedStep == questions.count - 1 ? "Submit" : "Next") {
                    withAnimation {
                        if selectedStep == questions.count - 1 {
                            submit()
                        } else {
                            selectedStep = selectedStep + 1
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 7)
                .foregroundStyle(Color.white)
                .background(.theme)
                .clipShape(Capsule())
            }
            .padding()
        }
    }

    private var questionsTabView: some View {
        VStack {
            TabView(selection: $selectedStep) {
                ForEach(
                    questions.indices,
                    id: \.self
                ) { index in
                    VStack(alignment: .leading, spacing: 0) {
                        Text(questions[index])
                            .font(.subheadline)
                            .padding(20)
                        Divider()
                        getQuestionView(number: index)
                            .tag(index)
                    }
                }
            }
            .background(.white)
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
        List {
            ForEach($jobs) { $choice in
                checkBox(
                    value: $choice.isSelected,
                    label: choice.job.name
                )
            }
        }
    }

    @ViewBuilder
    private var employeesView: some View {
        List {
            checkBox(
                value: Binding(
                    get: { employees.allSatisfy { $0.isSelected } },
                    set: { newValue in
                        employees.indices.forEach { employees[$0].isSelected = newValue }
                    }),
                label: "Select all employees"
            )
            ForEach($employees) { $choice in

                checkBox(
                    value: $choice.isSelected,
                    label: choice.employee.firstName + " " + choice.employee.lastName
                )
            }
        }
    }

    @ViewBuilder
    private var employeesPerJobView: some View {
        List {
            if jobs.filter({ $0.isSelected }).isEmpty {
                Text("Please select jobs first")
                    .foregroundColor(.red)
            } else {
                ForEach($jobs) { $jobChoice in
                    if jobChoice.isSelected {
                        HStack {
                            Text(jobChoice.job.name)
                            Spacer()
                            NumberInputView(number: $jobChoice.numberOfEmployees)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var extraInformationView: some View {
        List {
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
    }

    private func checkBox(
        value: Binding<Bool>,
        label: String
    ) -> some View {
        HStack {
            Image(
                systemName: value.wrappedValue ?
                "checkmark.square" :
                "square"
            )
                .foregroundColor(value.wrappedValue ? .theme : .gray)
            Text(label)
            Spacer()
        }
        .onTapGesture {
            value.wrappedValue.toggle()
        }
    }

    func submit() {
        isLoading = true
        Task {
            do {
                let answers = getAnswers()
                let response = try await ScheduleClient.suggestShifts(answers: answers)
                suggestedShifts = response.shifts
                if suggestedShifts.isEmpty {
                    self.errorMsg = LocalizedStringKey(
                        "No result, please try again."
                    )
                    self.showToast.toggle()
                } else {
                    showShiftsView.toggle()
                }
            } catch {
                self.errorMsg = LocalizedStringKey( error.localizedDescription
                )
                self.showToast.toggle()
            }
            isLoading = false
        }
    }

    private func getAnswers() -> [Answer] {
        [
            Answer(
                question: questions[0],
                answer: jobs
                    .filter({ $0.isSelected })
                    .map { $0.job.name }
                    .joined(separator: ", ")
            ),
            Answer(
                question: questions[1],
                answer: employees
                    .filter({ $0.isSelected })
                    .map { $0.employee.firstName + " " + $0.employee.lastName }
                    .joined(separator: ", ")
            ),
            Answer(
                question: questions[2],
                answer: jobs
                    .filter({ $0.isSelected })
                    .compactMap { jobChoice in
                        if let count = jobChoice.numberOfEmployees {
                            return "\(jobChoice.job.name): \(count)"
                        } else {
                            return nil
                        }
                    }
                    .joined(separator: ", ")
            ),
            Answer(
                question: questions[3],
                answer: description
            )
        ]
    }

    struct JobChoice: Identifiable, Equatable {
        var id = UUID()
        var job: Job
        var isSelected: Bool
        var numberOfEmployees: Int? = nil
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

struct Answer: Codable {
    var question: String
    var answer: String
}

// Subview using Binding
struct NumberInputView: View {
    @Binding var number: Int?

    var body: some View {
        TextField("Count", text: Binding<String>(
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
