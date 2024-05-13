//
//  ActivityCardView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct ActivityCardView: View {
    var icon: String
    var title: LocalizedStringKey
    var date: Date

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: date)
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(Color.theme)
                .frame(width: 45, height: 45)
                .background(Color.theme.opacity(0.1))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                Text(formattedDate)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(Color.gray)
            }

            Spacer()

            VStack(alignment: .leading, spacing: 5) {
                Text(date, style: .time)
                    .font(.system(size: 18, weight: .bold, design: .rounded))

                Text(LocalizedStringKey("On Time"))
                    .font(.system(size: 13, design: .rounded))
                    .foregroundStyle(Color.gray)
            }
        }
        .frame(height: 50)
        .padding(16)
        .foregroundStyle(Color.primary)
        .background(Color.whiteAndBlack)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    ActivityCardView(
        icon: "tray.and.arrow.down",
        title: "Check In",
        date: Date()
    )
}
