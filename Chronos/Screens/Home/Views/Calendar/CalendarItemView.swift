//
//  CalendarItemView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct CalendarItemView: View {

    var date: Date
    let dateFormatter = DateFormatter()

    var body: some View {
        VStack(
            spacing: 5
        ) {
            Text(date, format: .dateTime.day())
                .font(.title3)
                .fontWeight(.bold)

            Text(getDayName(for: date))
                .font(.system(size: 14))
        }
        .frame(width: 80, height: 80)
    }
}

extension CalendarItemView {

    private func getDayName(for date: Date) -> String {
        dateFormatter.dateFormat = "EEEE"
        let fullDayName = dateFormatter.string(from: date)
        return String(fullDayName.prefix(3)).capitalized
    }
}

#Preview {
    CalendarItemView(date: Date())
}
