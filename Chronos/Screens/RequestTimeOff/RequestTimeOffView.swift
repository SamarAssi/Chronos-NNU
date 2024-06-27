//
//  RequestTimeOffView.swift
//  Chronos
//
//  Created by Bassam Hillo on 27/06/2024.
//

import SwiftUI
import SimpleToast

struct RequestTimeOffView: View {

    @Environment(\.presentationMode) var presentationMode

    @State private var selectedType = TimeOffType.Unlimited
    @State private var selectedDuration = TimeOffDuration.fullDay
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var description = ""
    @State private var isSubmitting = false

    @State private var showToast = false
    @State private var errorMsg: LocalizedStringKey = ""
    @State var isButtonEnabled: Bool = false

    var body: some View {
        contentView
            .navigationTitle("Request Time Off")
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
                .onChange(of: description) {
                    isButtonEnabled = !description.isEmpty
                }
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            List {
                Picker("Type", selection: $selectedType) {
                    ForEach(TimeOffType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.automatic)

                Picker("Duration", selection: $selectedDuration) {
                    ForEach(TimeOffDuration.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.inline)

                if selectedDuration == .custom {
                    DatePicker("Start Date", selection: $startDate)
                    DatePicker("End Date", selection: $endDate)
                }

                VStack(alignment: .leading) {
                    Text(LocalizedStringKey("Description: "))
                        .foregroundColor(.black)

                    TextEditor(text: $description)
                        .font(.system(size: 15))
                        .textInputAutocapitalization(.never)
                        .scrollContentBackground(.hidden)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 200)
                }
            }
            .tint(Color.theme)

            MainButton(
                isLoading: $isSubmitting,
                isEnable: $isButtonEnabled,
                buttonText: "Submit",
                backgroundColor: .theme
            ) {
                submit()
            }
            .padding(20)
        }
    }

    func submit() {
        isSubmitting = true
        Task {
            do {
                let _ = try await RTOClient.createPTO(
                    type: selectedType.rawValue,
                    isFullDay: selectedDuration == .fullDay,
                    startDate: startDate,
                    endDate: endDate,
                    description: description
                )
                await MainActor.run {
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                self.errorMsg = LocalizedStringKey(
                    error.localizedDescription
                )
                self.showToast.toggle()
            }
        }
    }
}

#Preview {
    NavigationStack {
        RequestTimeOffView()
    }
}

enum TimeOffType: String, CaseIterable {
    case Unlimited = "Unlimited"
    case sick = "Sick Leave"
    case deathInFamily = "Death in Family"
    case weddingLeave = "Wedding Leave"
    case childCare = "Child Care"
    case hajLeave = "Haj Leave"
    case maternityLeave = "Maternity Leave"
}

enum TimeOffDuration: String, CaseIterable {
    case fullDay = "Full Day"
    case custom = "Custom"
}
