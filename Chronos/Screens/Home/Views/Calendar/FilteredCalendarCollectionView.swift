//
//  FilteredCalendarCollectionView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct FilteredCalendarCollectionView: View {
    @Binding var selectedDate: Date
    @Binding var dashboardResponse: DashboardResponse?
    @Binding var isLoading: Bool

    var startDate: Date
    var endDate: Date

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                HStack(
                    spacing: 10
                ) {
                    ForEach(
                        Date.generateDates(from: startDate, to: endDate),
                        id: \.self
                    ) { date in
                        CalendarItemView(
                            date: date
                        )
                        .foregroundStyle(selectedDate == date ? Color.white : Color.primary)
                        .background(adjustCalendarItemBackground(date: date))
                        .onTapGesture {
                            selectedDate = date
                        }
                        .onAppear {
                            if Date.isSameDay(date, as: Date()) {
                                proxy.scrollTo(date, anchor: .center)
                                selectedDate = date
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .onChange(of: selectedDate) {
            Task {
                showLoading()
                dashboardResponse = try await performDashboardRequest()
                hideLoading()
            }
        }
    }
}

extension FilteredCalendarCollectionView {
    private func adjustCalendarItemBackground(
        date: Date
    ) -> some View {
        HStack {
            if selectedDate == date {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.theme)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .fill(Color.gray.opacity(0.3))
            }
        }
    }

    private func performDashboardRequest() async throws -> DashboardResponse {
        return try await AuthenticationClient.dashboard(
            date: Int(selectedDate.timeIntervalSince1970)
        )
    }

    private func showLoading() {
        isLoading = true
    }

    private func hideLoading() {
        isLoading = false
    }
}

#Preview {
    FilteredCalendarCollectionView(
        selectedDate: .constant(Date()),
        dashboardResponse: .constant(nil),
        isLoading: .constant(false),
        startDate: Date(),
        endDate: Date()
    )
}
