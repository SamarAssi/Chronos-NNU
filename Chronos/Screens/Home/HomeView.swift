//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowProfileHeader = true
    @State private var showFullScreen = false
    @State private var selectedDate: Date?
    @State private var dashboardResponse: DashboardResponse?
    @State private var isLoading: Bool = true

    @EnvironmentObject var navigationRouter: NavigationRouter

    let startDate = Calendar.current.date(
        byAdding: .day,
        value: -30,
        to: Date()
    ) ?? Date()

    let endDate = Calendar.current.date(
        byAdding: .day,
        value: 30,
        to: Date()
    ) ?? Date()

    var body: some View {
        VStack(spacing: 0) {
            if !isLoading {
                if isShowProfileHeader {
                    ProfileHeaderView()
                        .padding(.trailing, 30)
                        .padding(.top)
                }

                FilteredCalendarCollectionView(
                    selectedDate: $selectedDate,
                    startDate: startDate,
                    endDate: endDate,
                    onUpdateSelectedDate: {
                        Task {
                            showLoading()
                            dashboardResponse = try await performDashboardRequest()
                            hideLoading()
                        }
                    }
                )
                .padding(.top, 20)
                .padding(.bottom)

                ZStack(alignment: .bottom) {
                    activityScrollView

                    SwipeToUnlockView(selectedDate: $selectedDate, width: 360)
                        .padding(.bottom, 20)
                }
                .background(
                    Color.silver
                        .opacity(0.1)
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .ignoresSafeArea(edges: .bottom)
                )
                .onAppear {
                    if let dashboardResponse = dashboardResponse {
                        if dashboardResponse.shouldShowOnboarding {
                            showFullScreen = true
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .fontDesign(.rounded)
        .animation(.easeInOut, value: isShowProfileHeader)
        .task {
            await handleDashboardResponse()
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            OnboardingView(showFullScreen: $showFullScreen)
        }
    }
}

extension HomeView {
    var activityScrollView: some View {
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
                            of: calculateVerticalContentOffset(proxy)
                        ) { oldVal, newVal in
                            adjustShowCalendarState(
                                from: oldVal,
                                to: newVal
                            )
                        }
                }
            )
        }
        .scrollIndicators(.hidden)
    }

    var attendanceView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(LocalizedStringKey("Today Attendance"))
                .fontWeight(.bold)
                .padding(.bottom)

            if let dashboardResponse = dashboardResponse {
                List(dashboardResponse.shifts, id: \.self) { shift in
                    ShiftView(shift: shift)
                }
            }
        }
    }

    var activityView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(LocalizedStringKey("Your Activity"))
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom)

            if let dashboardResponse = dashboardResponse {
                if dashboardResponse.activities.isEmpty {
                    Text(LocalizedStringKey("There is no activities yet!"))
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    activitiesListView(dashboardResponse: dashboardResponse)
                }
            }
        }
    }
}

extension HomeView {
    private func activitiesListView(
        dashboardResponse: DashboardResponse
    ) -> some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(dashboardResponse.activities, id: \.self) { activity in
                    ActivityCardView(
                        icon: "tray.and.arrow.down",
                        title: LocalizedStringKey("Check In"),
                        date: Date(timeIntervalSince1970: Double(activity.checkInTime / 1000))
                    )
                    .shadow(radius: 1)
                    .padding(5)
                }
            }
        }
    }

    private func calculateVerticalContentOffset(
        _ proxy: GeometryProxy
    ) -> CGFloat {
        return max(
            min(0, proxy.frame(in: .named("ScrollView")).minY),
            UIScreen.main.bounds.height - proxy.size.height
        )
    }

    private func adjustShowCalendarState<T: Comparable & Equatable>(
        from oldVal: T,
        to newVal: T
    ) {
        if (isShowProfileHeader && newVal < oldVal) || (!isShowProfileHeader && newVal > oldVal) {
            isShowProfileHeader = newVal > oldVal
        }
    }

    private func performDashboardRequest() async throws -> DashboardResponse {
        return try await AuthenticationClient.dashboard(
            date: Int(selectedDate?.timeIntervalSince1970 ?? 0)
        )
    }

    private func showLoading() {
        isLoading = true
    }

    private func hideLoading() {
        isLoading = false
    }

    private func handleDashboardResponse() async {
        do {
            showLoading()
            dashboardResponse = try await performDashboardRequest()
            hideLoading()
        } catch let error {
            print(error)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
