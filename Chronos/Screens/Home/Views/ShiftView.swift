//
//  ShiftView.swift
//  Chronos
//
//  Created by Samar Assi on 12/05/2024.
//

import SwiftUI

struct ShiftView: View {
    @State private var attendanceCards: [AttendanceCardModel] = []

    var shift: DashboardResponse.Shift

    var body: some View {
        HStack(
            spacing: 15
        ) {
            ForEach(attendanceCards) { attendanceCard in
                AttendanceCardView(
                    cardIcon: attendanceCard.cardIcon,
                    cardTitle: attendanceCard.cardTitle,
                    time: Date(timeIntervalSince1970: TimeInterval(attendanceCard.time)),
                    note: attendanceCard.note
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .shadow(radius: 1)
        .onAppear {
            setAttendanceCards()
        }
    }
}

extension ShiftView {
    private func setAttendanceCards() {
        attendanceCards = [
            AttendanceCardModel(
                cardIcon: "tray.and.arrow.down",
                cardTitle: LocalizedStringKey("Start Time"),
                time: shift.startTime,
                note: LocalizedStringKey("On Time")
            ),
            AttendanceCardModel(
                cardIcon: "tray.and.arrow.up",
                cardTitle: LocalizedStringKey("End Time"),
                time: shift.endTime,
                note: LocalizedStringKey("Go Home")
            )
        ]
    }
}

#Preview {
    ShiftView(
        shift: DashboardResponse.Shift(
            shiftName: "Start Shift",
            startTime: 0,
            endTime: 0,
            jobDescription: ""
        )
    )
}
