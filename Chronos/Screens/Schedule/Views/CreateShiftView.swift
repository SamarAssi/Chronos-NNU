//
//  CreateShiftView.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import SwiftUI

struct CreateShiftView: View {

    @ObservedObject private var viewModel = CreateShiftViewModel()
    @State private var showEmployeePicker = false
    @State private var showJobPicker = false
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        contentView()
            .onAppear {
                Task {
                    await viewModel.getData()
                }
            }
            .sheet(isPresented: $showEmployeePicker) {
                pickerView(
                    title: "Employee",
                    selection: $viewModel.selectedEmployeeID,
                    items: viewModel.employees.map { ($0.username, $0.id) }
                )
            }
            .sheet(isPresented: $showJobPicker) {
                pickerView(
                    title: "Job",
                    selection: $viewModel.selectedJobName,
                    items: viewModel.jobs.map { ($0.name, $0.name) }
                )
            }
    }

    private func contentView() -> some View {
        VStack(spacing: 0) {
            headerView()
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxHeight: .infinity)
            } else {
                formContent()
                MainButton(
                    isLoading: $viewModel.isSubmitting,
                    buttonText: "Create",
                    backgroundColor: .theme,
                    action: {
                        Task {
                            do {
                                try await viewModel.createShift()
                                await MainActor.run {
                                    presentationMode.wrappedValue.dismiss()
                                    selectedDate = Date()
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                )
                .padding()
            }
        }
    }

    private func headerView() -> some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            Text("Create Shift")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.theme)
                .padding()
            Divider()
        }
    }

    private func formContent() -> some View {
        List {
            pickerRow(
                label: "Start Date",
                selection: $viewModel.startDate,
                in: Date()...
            )
            pickerRow(
                label: "End Date",
                selection: $viewModel.endDate,
                in: viewModel.startDate...
            )
            selectRow(
                label: "Employee",
                value: viewModel.selectedEmployeeName
            )
            .onTapGesture {
                showEmployeePicker.toggle()
            }

            selectRow(
                label: "Job",
                value: viewModel.JobTitle
            )
            .onTapGesture {
                if !viewModel.jobs.isEmpty {
                    showJobPicker.toggle()
                }
            }
        }
    }

    private func pickerRow(
        label: LocalizedStringKey,
        selection: Binding<Date>,
        in range: PartialRangeFrom<Date>
    ) -> some View {

        DatePicker(
            selection: selection,
            in: range,
            displayedComponents: [.date, .hourAndMinute]
        ) {
            Text(label)
                .foregroundColor(.theme)
        }
        .datePickerStyle(.compact)
        .tint(Color.theme)
    }

    private func selectRow(
        label: LocalizedStringKey,
        value: String?
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

    private func pickerView<T: Hashable>(
        title: String,
        selection: Binding<T?>,
        items: [(String, T)]
    ) -> some View {
        Picker(
            title,
            selection: selection
        ) {
            ForEach(items, id: \.1) { item in
                Text(item.0).tag(item.1 as T?)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .presentationDetents([.height(200)])
    }
}

#Preview {
    CreateShiftView(selectedDate: .constant(Date()))
}
