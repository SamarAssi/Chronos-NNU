//
//  SuggestedShiftsView.swift
//  Chronos
//
//  Created by Bassam Hillo on 25/06/2024.
//

import SwiftUI

struct SuggestedShiftsView: View {

    @Environment(\.presentationMode) var presentationMode
    @State var uiModels: [ShiftRowUIModel]
    @State var isSubmitting = false
    private let shifts: [Shift]

    init(shifts: [Shift]) {
        self.shifts = shifts

        let acronymManager = AcronymManager()
        self.uiModels = shifts.compactMap { shift in

            let name = shift.employeeName
            let id = shift.employeeID
            let (initials, backgroundColor) = acronymManager.getAcronymAndColor(name: name, id: id ?? "")

            let startTime = shift.startTime?.stringTime ?? "--"
            let endTime = shift.endTime?.stringTime ?? "--"
            let titleString: String = name ?? "--"

            return ShiftRowUIModel(
                id: "\(UUID())",
                initials: initials,
                title: titleString,
                startTime: startTime,
                endTime: endTime,
                backgroundColor: backgroundColor,
                isNew: shift.isNew == true
            )
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                listView
                Divider()
                    .padding(.bottom)
                buttonsView
            }

            if isSubmitting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .theme))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.2))
                    .ignoresSafeArea()
                    .animation(.easeInOut, value: isSubmitting)
            }
        }
        .navigationTitle("Suggested Shifts")
    }

    private var listView: some View {
        List(uiModels) { event in
            ShiftRowView(model: event)
                .listRowSeparator(.hidden)
                .listRowInsets(
                    EdgeInsets(
                        top: 16,
                        leading: 18,
                        bottom: 0,
                        trailing: 18
                    )
                )
        }
        .listStyle(.plain)
    }

    private var buttonsView: some View {
        HStack {
            buttonView(
                title: "REJECT",
                backgroundColor: .red,
                action: {
                    presentationMode.wrappedValue.dismiss()
                }
            )

            buttonView(
                title: "APPROVE",
                backgroundColor: .theme,
                action: {
                    acceptShifts()
                }
            )
        }
        .padding(.horizontal)
    }

    private func buttonView(
        title: String,
        backgroundColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .font(.system(size: 14, weight: .bold))
                .padding(.vertical, 15)
                .background(backgroundColor.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    func acceptShifts() {
        isSubmitting = true
        Task {
            do {
                let shifts = try await ScheduleClient.createShifts(shifts: Shifts(shifts: shifts))
                print(shifts)
            } catch {
                print(error)
            }
            await MainActor.run {
                isSubmitting = false
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

#Preview {
    let shifts = [
        Shift(
            id: "1",
            role: "Manager",
            startTime: "1719392400",
            endTime: "1624622400",
            jobDescription: "Managerial duties",
            employeeID: "1",
            employeeName: "John Doe",
            isNew: true
        ),
    ]
    return NavigationStack {
        SuggestedShiftsView(shifts: shifts)
    }
}
