//
//  AttendanceCardView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct AttendanceCardView: View {
    var cardIcon: String
    var cardTitle: LocalizedStringKey
    var time: Date
    var note: LocalizedStringKey

    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 10
        ) {
            HStack(spacing: 8) {
                Image(systemName: cardIcon)
                    .foregroundStyle(Color.theme)
                    .frame(width: 40, height: 40)
                    .background(Color.theme.opacity(0.1))
                    .cornerRadius(10)

                Text(cardTitle)
            }
            .padding(.bottom, 8)

            Text(time, style: .time)
                .font(.title3)
                .fontWeight(.bold)

            Text(note)
                .font(.subheadline)
        }
        .frame(width: 130)
        .padding(16)
        .foregroundStyle(Color.primary)
        .background(Color.whiteAndBlack)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

#Preview {
    AttendanceCardView(
        cardIcon: "tray.and.arrow.down",
        cardTitle: "Check In",
        time: Date(),
        note: "On Time"
    )
}
