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
        "What jobs need to be scheduled?",
        "Who needs to be scheduled?",
        "What are the start and end dates for the shifts?",
        "How many employees are required for each job?",
        "Any extra information?"
    ]

    // State to track the selected choices
    @State private var jobs: [JobChoice] = []
    @State private var employees: [EmployeeChoice] = []
    @State private var description: String = ""
    @State private var isLoading = false

    @State var startDate: Date = {
        let calendar = Calendar.current
        return calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: Date())
        )!
    }()
    @State var endDate: Date = {
        let calendar = Calendar.current
        return calendar.date(
            byAdding: .day,
            value: 2,
            to: calendar.startOfDay(for: Date())
        )!
    }()

    @State var showShiftsView = false
    @State var errorMsg: LocalizedStringKey = ""
    @State var showToast = false
    @State var suggestedShifts: [Shift] = []

    private var mainButtonText: String {
        if questions.count - 1 == selectedStep {
            return "Submit"
        } else {
            return "Next"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .theme))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .animation(.easeInOut, value: isLoading)
                } else {
                    contendView
                }
            }
            .toolbar {
                if selectedStep > 0 {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            withAnimation {
                                selectedStep = selectedStep - 1
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.theme)
                                .bold()
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            if selectedStep == questions.count - 1 {
                                submit()
                            } else {
                                selectedStep = selectedStep + 1
                            }
                        }
                    } label: {
                        Text(mainButtonText)
                            .foregroundStyle(.theme)
                            .bold()
                    }
                }
            }
            .navigationTitle("Shifts Suggestions")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showShiftsView) {
                SuggestedShiftsView(shifts: suggestedShifts)
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
                    isLoading = true
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
                            self.errorMsg = LocalizedStringKey( error.localizedDescription
                            )
                            self.showToast.toggle()
                        }

                        await MainActor.run {
                            isLoading = false
                        }
                    }
                }
        }
    }

    private var contendView: some View {
        VStack(spacing: 0) {
            progressLine
            questionsTabView
        }
    }

    private var questionsTabView: some View {
        VStack {
            TabView(selection: $selectedStep) {
                ForEach(
                    questions.indices,
                    id: \.self
                ) { index in
                    VStack(spacing: 0) {
                        getQuestionView(
                            number: index,
                            question: questions[index]
                        )
                        .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }

    @ViewBuilder
    private func getQuestionView(number: Int, question: String) -> some View {
        switch number {
        case 0 : JobsSelectorView(
            jobs: $jobs,
            question: question
        )
        case 1: EmployeesSelectorView(
            employees: $employees,
            question: question
        )
        case 2:
            AIDatePicker(
                startDate: $startDate,
                endDate: $endDate,
                label: question
            )
        case 3: EmployeesPerJobView(
            jobs: $jobs,
            question: question
        )
        case 4: ExtraInformationView(
            description: $description,
            question: question
        )
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private var progressLine: some View {
        HStack(spacing: 0) {
            Rectangle()
                .foregroundColor(.theme)
                .frame(width: CGFloat(selectedStep + 1) / CGFloat(questions.count) * UIScreen.main.bounds.width)
            Rectangle()
                .foregroundColor(.gray.opacity(0.25))
        }
        .animation(.easeInOut, value: selectedStep)
        .frame(height: 5)
    }

    func submit() {
        guard isLoading == false else {
            return
        }

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
                self.errorMsg = LocalizedStringKey(error.localizedDescription)
                self.showToast.toggle()
            }
            isLoading = false
        }
    }

    private func getAnswers() -> [Answer] {
        let dateFormate = "yyyy-MM-dd'T'00:00:00"
        return [
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
                answer: "\(startDate.toString(format: dateFormate)) - \(endDate.toString(format: dateFormate))"
            ),
            Answer(
                question: questions[3],
                answer: jobs
                    .filter({ $0.isSelected })
                    .compactMap { jobChoice in
                        let minCount = jobChoice.minNumberOfEmployees
                        let maxNumberOfEmployees = jobChoice.maxNumberOfEmployees
                        
                        var answer: String? = nil

                        if let minCount = minCount, let maxNumberOfEmployees = maxNumberOfEmployees {
                            answer = "\(minCount) - \(maxNumberOfEmployees)"
                        } else if let minCount = minCount {
                            answer = "\(minCount) or more"
                        } else if let maxNumberOfEmployees = maxNumberOfEmployees {
                            answer = "Up to \(maxNumberOfEmployees)"
                        } else {
                            return nil
                        }

                        return "\(jobChoice.job.name): \(answer!)"
                    }
                    .joined(separator: ", ")
            ),
            Answer(
                question: questions[4],
                answer: description
            )
        ]
    }
}

#Preview {
    ShiftsSuggestionsView()
}

struct Answer: Codable {
    var question: String
    var answer: String
}
