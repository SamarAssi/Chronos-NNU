//
//  AIDatePicker.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI


struct AIDatePicker: View {

    @Binding var startDate: Date
    @Binding var endDate: Date

    @Binding var startTime: Date
    @Binding var endTime: Date

    let label: String

    var body: some View {
        List {
            Section {
                Image(.date)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .listRowSeparator(.hidden)
                    .padding(.bottom, 5)
                DatePicker(
                    "Start Date",
                    selection: $startDate,
                    displayedComponents: [.date]
                )
                DatePicker(
                    "End Date",
                    selection: $endDate,
                    displayedComponents: [.date]
                )
            }
            Section("Shift time interval") {
                DatePicker(
                    "Start Time",
                    selection: $startTime,
                    displayedComponents: [.hourAndMinute]
                )
                DatePicker(
                    "End Time",
                    selection: $endTime,
                    displayedComponents: [.hourAndMinute]
                )
            }

        }
        .tint(.theme)
    }
}

#Preview {
    AIDatePicker(
        startDate: .constant(Date()),
        endDate: .constant(Date()),
        startTime: .constant(Date()),
        endTime: .constant(Date()),
        label: "Select a date range"
    )
}
