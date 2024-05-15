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
    @State private var isCheckedIn = false
    @State private var selectedDate: Date = Date()

    @StateObject var homeModel = HomeModel()
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
        VStack(
            spacing: 0
        ) {
            if isShowProfileHeader {
                ProfileHeaderView()
                    .padding(.trailing, 30)
                    .padding(.top)
            }
            
            FilteredCalendarCollectionView(
                selectedDate: $selectedDate,
                dashboardResponse: $homeModel.dashboardResponse,
                isLoading: $homeModel.isLoading,
                startDate: startDate,
                endDate: endDate
            )
            .padding(.top, 20)
            .padding(.bottom)
            
            dashboardContent
        }
        .fontDesign(.rounded)
        .animation(.easeInOut, value: isShowProfileHeader)
        .fullScreenCover(isPresented: $showFullScreen) {
            NavigationStack {
                OnboardingView(showFullScreen: $showFullScreen)
            }
        }
        .task {
            await homeModel.handleDashboardResponse(selectedDate: selectedDate)
        }
    }
}

// MARK: - Computed Properties

extension HomeView {
    var dashboardContent: some View {
        ZStack(
            alignment: .bottom
        ) {
            if !homeModel.isLoading {
                activityScrollView
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(
                            CircularProgressViewStyle(tint: Color.theme)
                        )
                        .scaleEffect(1.5, anchor: .center)
                        .offset(y: -10)
                    Spacer()
                }
            }
            
            if getDate(date: selectedDate) == getDate(date: Date()) {
                SwipeToUnlockView(
                    isCheckedIn: $isCheckedIn,
                    width: 360
                )
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Color.silver
                .opacity(0.1)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .ignoresSafeArea(edges: .bottom)
        )
    }
    
    var activityScrollView: some View {
        ScrollView {
            LazyVStack(
                alignment: .leading,
                spacing: 15
            ) {
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
        .onAppear {
            isShowProfileHeader = true
            if let dashboardResponse = homeModel.dashboardResponse {
                if dashboardResponse.shouldShowOnboarding {
                    showFullScreen = true
                }
            }
            checkIn()
        }
    }
    
    var attendanceView: some View {
        VStack(
            alignment: .leading,
            spacing: 15
        ) {
            Text(LocalizedStringKey("Today Attendance"))
                .fontWeight(.bold)
                .padding(.bottom)
            
            if let dashboardResponse = homeModel.dashboardResponse {
                List(dashboardResponse.shifts, id: \.self) { shift in
                    ShiftView(shift: shift)
                }
            }
        }
    }
    
    var activityView: some View {
        VStack(
            alignment: .leading,
            spacing: 15
        ) {
            Text(LocalizedStringKey("Your Activity"))
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom)
            
            if let dashboardResponse = homeModel.dashboardResponse {
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

// MARK: - Mehtods

extension HomeView {
    private func activitiesListView(
        dashboardResponse: DashboardResponse
    ) -> some View {
//        List(dashboardResponse.activities, id: \.self) { activity in
//            ActivityCardView(
//                icon: "tray.and.arrow.down",
//                title: LocalizedStringKey("Check In"),
//                date: Date(timeIntervalSince1970: Double(activity.checkInTime / 1000))
//            )
//            .shadow(radius: 1)
//            .padding(5)
//        }
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
    
    private func getDate(
        date: Date
    ) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: date)
    }
    
    private func checkIn() {
        if homeModel.dashboardResponse?.activities.last?.checkOutTime == nil {
            isCheckedIn = true
        } else {
            isCheckedIn = false
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
