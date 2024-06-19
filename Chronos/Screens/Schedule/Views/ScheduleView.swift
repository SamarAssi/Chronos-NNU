//
//  ScheduleView.swift
//  Chronos
//
//  Created by Bassam Hillo on 19/06/2024.
//

import SwiftUI
import SimpleCalendar

struct ScheduleView: View {

    @State var selectedDate: Date = Date()
    @State var events: [any CalendarEventRepresentable] = []
    @State var showCreateEventView = false

    var body: some View {
        VStack(alignment: .leading) {
            TitleView()
            ZStack {
                CalendarDateView()
                FloatingButton()
            }
        }
        .sheet(isPresented: $showCreateEventView) {
            CreateShiftView()
        }
        .task {
            await getData()
        }
    }

    private func TitleView() -> some View {
        Text("Schedule")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.theme)
            .padding()
    }

    private func FloatingButton() -> some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FloatingActionButton()
            }
        }
    }

    private func FloatingActionButton() -> some View {
        Button(action: {
            showCreateEventView.toggle()
        }) {
            Circle()
                .foregroundColor(.theme)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                )
                .padding()
        }
    }

    private func CalendarDateView() -> some View {
        VStack {
            DatePicker(
                selection: $selectedDate,
                displayedComponents: [.date],
                label: {
                    Text("Select a date")
                        .foregroundColor(.theme)
                }
            )
            .datePickerStyle(.compact)
            .padding(.horizontal)
            .tint(Color.theme)

            Divider()

            SimpleCalendarView(
                events: $events,
                selectedDate: $selectedDate,
                selectionAction: .sheet
            )
        }
    }

    private func getData() async {
        do {
            let shifts = try await ScheduleClient.getShifts()
            events = shifts.shifts.compactMap { shift in
                let startDate = Date(
                    timeIntervalSince1970: TimeInterval(shift.startTime ?? 0)
                )
                let duration: Double = Double((shift.endTime ?? 0) - (shift.startTime ?? 0))

                return CalendarEvent(
                    id: "\(UUID())",
                    startDate: startDate,
                    activity: CalendarActivity(
                        id: "\(UUID())",
                        title: shift.role ?? "Unknown",
                        description: shift.jobDescription ?? "Unknown",
                        mentors: [shift.employeeName ?? "Unknown"],
                        type: ActivityType(
                            name: shift.role ?? "Unknown",
                            color: [.yellow, .red, .green, .blue].randomElement()!
                        ),
                        duration: duration
                    )
                )
            }

        } catch {
            print(error)
        }
    }
}

#Preview {
    ScheduleView()
}
