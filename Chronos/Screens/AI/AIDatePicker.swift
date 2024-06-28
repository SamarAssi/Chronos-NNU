//
//  AIDatePicker.swift
//  Chronos
//
//  Created by Bassam Hillo on 28/06/2024.
//

import SwiftUI


struct AIDatePicker: View {

    @Binding var startDate: Date
    @Binding var endDate: Date
    let label: String

    var body: some View {
        List {

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

            DatePicker("Start Date", selection: $startDate)
            DatePicker("End Date", selection: $endDate)
        }
        .tint(.theme)
    }
}

#Preview {
    AIDatePicker(
        startDate: .constant(Date()),
        endDate: .constant(Date()),
        label: "Select a date range"
    )
}
