//
//  CreateShiftView.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import SwiftUI

struct CreateShiftView: View {

    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State var selectedEmployeeID: String?
    @State var selectedJobName: String?

    @State var employees: [Employee] = []

    @State var showEmployeePicker: Bool = false
    @State var showJobPicker: Bool = false
    @State var isLoading: Bool = false
    @State var isSubmitting: Bool = false

    var selectedEmployeeName: String? {
        employees.first { $0.id == selectedEmployeeID }?.username
    }

    var jobs: [Job] {
        employees.first { $0.id == selectedEmployeeID }?.jobs ?? []
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                ContentView()
            }

        }
        .task {
            isLoading = true
            do {
                employees = try await EmployeesClient.getEmployees().employees
                isLoading = false
            } catch {
                print(error)
            }
        }
    }

    private func ContentView() -> some View {
        VStack(alignment: .leading) {

            Text("Create Shift")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.theme)
                .padding()
            Spacer()

            List {
                PickerRow(
                    label: "Start Date",
                    selection: $startDate,
                    in: Date()...
                )

                PickerRow(
                    label: "End Date",
                    selection: $endDate,
                    in: startDate...
                )

                SelectRow(
                    label: "Employee",
                    value: selectedEmployeeName
                )
                .onTapGesture {
                    if !employees.isEmpty {
                        showEmployeePicker.toggle()
                    }
                }

                SelectRow(
                    label: "Job",
                    value: selectedJobName
                )
                .onTapGesture {
                    if !jobs.isEmpty {
                        showJobPicker.toggle()
                    }
                }
            }

            MainButton(
                isLoading: $isSubmitting,
                buttonText: "Create",
                backgroundColor: .theme) {
                    isSubmitting = true
                    Task {
                        do {
                            let _ = try await ScheduleClient.createShift(
                                role: selectedJobName ?? "",
                                startTime: Int(startDate.timeIntervalSince1970),
                                endTime: Int(endDate.timeIntervalSince1970),
                                employeeId: selectedEmployeeID ?? "",
                                jobDescription: "Test"
                            )
                            isSubmitting = false
                        } catch {
                            print(error)
                        }
                    }
                }
                .padding()
        }
        .sheet(isPresented: $showEmployeePicker) {
            Picker("Employee", selection: $selectedEmployeeID) {
                ForEach(employees) { employee in
                    Text(employee.username).tag(employee.id as String?)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
        .sheet(isPresented: $showJobPicker) {
            Picker("Job", selection: $selectedJobName) {
                ForEach(jobs) { job in
                    Text(job.name).tag(job.name as String?)
                }
            }
            .pickerStyle(WheelPickerStyle())
        }
    }

    private func PickerRow(
        label: LocalizedStringKey,
        selection: Binding<Date>,
        in range: PartialRangeFrom<Date>
    ) -> some View {
        DatePicker(
            selection: selection,
            in: range,
            displayedComponents: [
                .date,
                .hourAndMinute
            ],
            label: {
                Text(label)
                    .foregroundColor(.theme)
            }
        )
        .datePickerStyle(.compact)
        .tint(Color.theme)
    }

    private func SelectRow(
        label: LocalizedStringKey,
        value: String? = nil
    ) -> some View {

        HStack {
            Text(label)
                .foregroundColor(.theme)
            Spacer()

            Text(value ?? "Select")
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }
}

#Preview {
    CreateShiftView()
}
