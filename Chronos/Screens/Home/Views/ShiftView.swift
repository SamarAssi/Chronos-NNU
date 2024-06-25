//
//  ShiftView.swift
//  Chronos
//
//  Created by Samar Assi on 12/05/2024.
//

import SwiftUI

struct ShiftView: View {

    @State private var attendanceCards: [AttendanceCardModel] = []

    var shift: Shift

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
                time: shift.startTime ?? 0,
                note: LocalizedStringKey("On Time")
            ),
            AttendanceCardModel(
                cardIcon: "tray.and.arrow.up",
                cardTitle: LocalizedStringKey("End Time"),
                time: shift.endTime ?? 0,
                note: LocalizedStringKey("Go Home")
            )
        ]
    }
}

#Preview {
    ShiftView(
        shift: Shift(
            id: "",
            role: "",
            startTime: 0,
            endTime: 0,
            jobDescription: "",
            employeeID: "",
            employeeName: "",
            isNew: true
        )
    )
}
