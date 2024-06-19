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

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                contentView()
            }
        }
        .task {
            await viewModel.getData()
        }
    }

    private func contentView() -> some View {
        VStack(spacing: 0) {
            headerView()
            formContent()
            MainButton(
                isLoading: $viewModel.isSubmitting,
                buttonText: "Create",
                backgroundColor: .theme,
                action: viewModel.createShift
            )
            .padding()
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
    CreateShiftView()
}
