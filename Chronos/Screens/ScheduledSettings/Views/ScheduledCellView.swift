//
//  ScheduledCellView.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI

struct ScheduledCellView: View {
    var job: Job

    var body: some View {
        VStack {
            HStack {
                Text(job.name)
                Spacer()
                Image(systemName: "chevron.down")
                    .onTapGesture {
                        withAnimation(.easeIn) {
                        }
                    }
            }
        }
    }
}

#Preview {
    ScheduledCellView(
        job: Job(
            id: "",
            name: "",
            sundaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
            mondaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
            tuesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
            wednesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
            thursdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
            fridaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
            saturdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1)
        )
    )
}
