//
//  CreateShiftView.swift
//  Chronos
//
//  Created by Samar Assi on 19/06/2024.
//

import SwiftUI
import SimpleToast

struct CreateShiftView: View {

    @ObservedObject private var viewModel = CreateShiftViewModel()
    
    @State private var showEmployeePicker = false
    @State private var showJobPicker = false
    @State private var showToast = false
    
    @Binding var selectedDate: Date
    @Binding var shifts: [ShiftRowUI]
    @Binding var filteredShifts: [ShiftRowUI]
    @Binding var showAllEmployees: Bool

    @Environment(\.dismiss) var dismiss
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )

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
                    items: viewModel.employees.map { ($0.firstName + " " + $0.lastName, $0.id) }
                )
            }
            .sheet(isPresented: $showJobPicker) {
                pickerView(
                    title: "Job",
                    selection: $viewModel.selectedJobName,
                    items: viewModel.jobs.map { ($0.name, $0.name) }
                )
            }
            .simpleToast(isPresented: $showToast, options: toastOptions) {
                ToastView(type: .error, message: "Overlapping shifts found")
                    .padding(.horizontal)
                    .padding(.top)
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

                Divider()
                MainButton(
                    isLoading: $viewModel.isSubmitting, 
                    isEnable: $viewModel.isButtonEnabled,
                    buttonText: "Create",
                    backgroundColor: .theme,
                    action: {
                        Task {
                            do {
                                try await viewModel.createShift()
                                await MainActor.run {
                                    dismiss.callAsFunction()
                                    selectedDate = Date()
                                }
                                
                                if let createdShift = viewModel.createdShift {
                                    if showAllEmployees {
                                        shifts.append(createdShift)
                                    } else {
                                        filteredShifts.append(createdShift)
                                    }
                                }
                            } catch {
                                showToast = true
                                viewModel.isSubmitting = false
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
            HStack {
                Text(LocalizedStringKey("Create Shift"))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.theme)
                    .padding()

                Spacer()

                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.theme)
                        .padding()
                }
            }
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

            descriptionView
        }
        .scrollDismissesKeyboard(.interactively)
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
                .foregroundColor(.blackAndWhite)
                .clipShape(RoundedRectangle(cornerRadius: 7))
        }
    }

    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey("Description: "))
                .foregroundColor(.theme)

            TextEditor(text: $viewModel.description)
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
    CreateShiftView(
        selectedDate: .constant(Date()),
        shifts: .constant([]),
        filteredShifts: .constant([]),
        showAllEmployees: .constant(false)
    )
}
