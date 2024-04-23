//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = MainViewModel()

    var allActivitiesButtonColor: Color {
        viewModel.activities.isEmpty ?
        Color.gray :
        Color.theme
    }

    var isAllActivitiesButtonDisabled: Bool {
        viewModel.activities.isEmpty ?
        true :
        false
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isShowProfileHeader {
                ProfileHeaderView()
                    .padding(.trailing, 30)
                    .padding(.top)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        )
                    )
            }

            horizontalCalenderView

            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        attendanceView
                        activityView
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                    .padding(.horizontal, 20)
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onChange(
                                    of: viewModel.calculateVerticalContentOffset(proxy)
                                ) { oldVal, newVal in
                                    viewModel.adjustShowCalendarState(
                                        from: oldVal,
                                        to: newVal
                                    )
                                }
                        }
                    )
                }
                .scrollIndicators(.hidden)

                SwipeToUnlockView(
                    width: 360
                )
                .transition(
                    AnyTransition.scale.animation(
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.5
                        )
                    )
                )
                .padding(.bottom, 20)
            }
        }
        .fontDesign(.rounded)
        .animation(.easeInOut, value: viewModel.isShowProfileHeader)
    }
}

extension HomeView {
    var horizontalCalenderView: some View {
        HorizontalCalendarView(
            startDate: viewModel.startDate,
            endDate: viewModel.endDate
        )
        .padding(.top, 20)
    }

    var attendanceView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(LocalizedStringKey("Today Attendance"))
                .fontWeight(.bold)
                .padding(.bottom)

            HStack(spacing: 15) {
                AttendanceCardView(
                    cardIcon: "tray.and.arrow.down",
                    cardTitle: LocalizedStringKey("Check In"),
                    time: LocalizedStringKey("10:20 am"),
                    note: LocalizedStringKey("On Time")
                )
                .shadow(radius: 1)

                AttendanceCardView(
                    cardIcon: "tray.and.arrow.up",
                    cardTitle: LocalizedStringKey("Check Out"),
                    time: LocalizedStringKey("7:00 am"),
                    note: LocalizedStringKey("Go Home")
                )
                .shadow(radius: 1)
            }
        }
    }

    var activityView: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Your Activity")
                    .fontWeight(.bold)

                Spacer()

                Button {

                } label: {
                    Text("View All")
                }
                .font(.system(size: 16))
                .foregroundStyle(allActivitiesButtonColor)
                .disabled(isAllActivitiesButtonDisabled)
            }
            .padding(.top, 20)
            .padding(.bottom)

            if viewModel.activities.isEmpty {
                Text("There is no activities yet!")
                    .font(.subheadline)
            } else {
                ActivityCardView(
                    icon: "",
                    title: "",
                    time: "",
                    date: Date()
                )
            }
        }
    }
}

#Preview {
    HomeView()
}
