//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI
import SimpleToast

struct HomeView: View {
    
    @StateObject private var homeModel = HomeModel()
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @State private var isShowProfileHeader = true
    @State private var showFullScreen = false
    @State private var isCheckedIn = false
    @State private var isInvalidCheckInOut = false
    @State private var showOffEmployeesSheet = false
    
    @State private var selectedDate: Date = Date()
    @State private var employeeId: String?
    
    @State private var scrollOffset: CGFloat = 0
    @State private var lastScrollOffset: CGFloat = 0
    @State private var showReport = false
    
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
    
    private let toastOptions = SimpleToastOptions(
        alignment: .top,
        hideAfter: 5,
        animation: .linear(duration: 0.3),
        modifierType: .slide,
        dismissOnTap: true
    )
    
    var activityTitle: LocalizedStringKey {
        fetchEmployeeType() == 0 ?
        "Your Activity" :
        "Your Employees Activity"
    }
    
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
                homeModel: homeModel,
                selectedDate: $selectedDate,
                dashboardResponse: $homeModel.dashboardResponse,
                isLoading: $homeModel.isLoading,
                startDate: startDate,
                endDate: endDate
            )
            .padding(.top, 20)
            .padding(.bottom)
            
            dashboardContent
                .safeAreaInset(edge: .bottom) {
                    if UserDefaultManager.employeeType == 1 {
                        MainButton(
                            isLoading: .constant(false),
                            isEnable: .constant(true),
                            buttonText: "Employees Report",
                            backgroundColor: .theme
                        ) {
                            showReport = true
                        }
                        .padding()
                    }
                }
        }
        .sheet(isPresented: $showReport) {
            EmployeesReportView()
        }
        .sheet(isPresented: $showOffEmployeesSheet) {
            OffEmployeesListView(
                offEmployees: homeModel.timeOffRequestRowUIModel
            )
        }
        .fontDesign(.rounded)
        .animation(.easeInOut, value: isShowProfileHeader)
        .fullScreenCover(isPresented: $showFullScreen) {
            NavigationStack {
                OnboardingView(showFullScreen: $showFullScreen)
            }
        }
        .onAppear {
            homeModel.handleDashboardResponse(
                selectedDate: selectedDate,
                employeeId: employeeId ?? ""
            )
            homeModel.getEmployeesList()
        }
        .simpleToast(
            isPresented: $isInvalidCheckInOut,
            options: toastOptions
        ) {
            ToastView(
                type: .warning,
                message: "You are not inside the allowed space of location"
            )
            .padding(.horizontal)
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
                CustomProgressView()
            }
            
            if fetchEmployeeType() == 0 {
                if getDate(date: selectedDate) == getDate(date: Date()) {
                    SwipeToUnlockView(
                        homeModel: homeModel,
                        isCheckedIn: $isCheckedIn,
                        selectedDate: $selectedDate,
                        isInvalidCheckInOut: $isInvalidCheckInOut,
                        width: 360
                    )
                    .padding(.bottom, 20)
                }
            }
        }
        .background(
            Color.silver
                .frame(width: UIScreen.main.bounds.width)
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
                if !homeModel.timeOffRequestRowUIModel.isEmpty {
                    offEmployeesListView
                    //                        .padding(.leading, 18)
                    //                        .padding(.trailing, 10)
                }
                activityView
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
            .padding(.horizontal, 18)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onChange(
                            of: proxy.frame(in: .named("ScrollView")).minY
                        ) { newValue, oldValue in
                            adjustShowHeaderState(
                                oldVal: oldValue,
                                newVal: newValue
                            )
                        }
                }
            )
        }
        .coordinateSpace(name: "ScrollView")
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
            if let dashboardResponse = homeModel.dashboardResponse {
                Text(LocalizedStringKey("Today's Total Shifts Time:  "))
                    .fontWeight(.bold)
                +
                Text(dashboardResponse.shiftsTotalTime)
                    .font(.title2)
            }
        }
    }
    
    var offEmployeesListView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(LocalizedStringKey("Who's Out"))
                    .fontWeight(.bold)
                
                Spacer()
                
                if homeModel.timeOffRequestRowUIModel.count > 3 {
                    viewAllButton
                }
            }
            
            
            let firstThreeCells = homeModel.timeOffRequestRowUIModel.prefix(3)
            ForEach(firstThreeCells) { rowModel in
                OffEmployeeRowView(rowModel: rowModel)
                    .shadow(color: Color.blackAndWhite.opacity(0.3), radius: 1)
            }
        }
    }
    
    var viewAllButton: some View {
        Button {
            showOffEmployeesSheet = true
        } label: {
            Text(LocalizedStringKey("View all"))
                .foregroundStyle(Color.theme)
                .font(.subheadline)
        }
    }
    
    var activityView: some View {
        VStack(
            alignment: .leading,
            spacing: 15
        ) {
            HStack {
                Text(activityTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.bottom)
                Spacer()
                
                if fetchEmployeeType() == 1 {
                    filterButtonView
                }
            }
            
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
    
    var filterButtonView: some View {
        Menu {
            ForEach(homeModel.employees) { employee in
                Button {
                    employeeId = employee.id
                    homeModel.handleDashboardResponse(
                        selectedDate: selectedDate,
                        employeeId: employeeId ?? ""
                    )
                } label: {
                    Text(employee.firstName + " " + employee.lastName)
                }
            }
            
            Button {
                homeModel.handleDashboardResponse(
                    selectedDate: selectedDate,
                    employeeId: ""
                )
            } label: {
                Text(LocalizedStringKey("Clear"))
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundStyle(homeModel.employees.isEmpty ? Color.gray : Color.blackAndWhite)
        }
        .disabled(homeModel.employees.isEmpty)
    }
}

// MARK: - Mehtods

extension HomeView {
    
    private func activitiesListView(
        dashboardResponse: DashboardResponse
    ) -> some View {
        LazyVStack(
            spacing: 8
        ) {
            ForEach(
                dashboardResponse.activities.reversed(),
                id: \.self
            ) { activity in
                
                VStack {
                    if let checkout = activity.checkOutTime {
                        ActivityCardView(
                            icon: "tray.and.arrow.up",
                            title: "Check Out",
                            date: checkout.date ?? Date(),
                            iconColor: Color.red,
                            employeeName: activity.employeeName
                        )
                        .shadow(color: Color.blackAndWhite, radius: 1)
                        .padding(.vertical, 5)
                    }
                    
                    ActivityCardView(
                        icon: "tray.and.arrow.down",
                        title: "Check In",
                        date: activity.checkInTime.date ?? Date(),
                        iconColor: Color.theme,
                        employeeName: activity.employeeName
                    )
                    .shadow(color: Color.blackAndWhite, radius: 1)
                    .padding(.vertical, 5)
                    
                }
            }
        }
    }
    
    private func updateHeaderVisibility(_ currentScrollOffset: CGFloat) {
        let delta = currentScrollOffset - lastScrollOffset
        
        if delta > 5 && !isShowProfileHeader {
            // Scrolling up
            withAnimation {
                isShowProfileHeader = true
            }
        } else if delta < -5 && isShowProfileHeader && currentScrollOffset < 0 {
            // Scrolling down
            withAnimation {
                isShowProfileHeader = false
            }
        }
        
        lastScrollOffset = currentScrollOffset
    }
    
    private func adjustShowHeaderState(
        oldVal: CGFloat,
        newVal: CGFloat
    ) {
        let threshold: CGFloat = 18
        if newVal < -threshold && newVal > oldVal {
            isShowProfileHeader = false
        } else if newVal > 0 {
            isShowProfileHeader = true
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
        if let dashboardResponse = homeModel.dashboardResponse {
            if !dashboardResponse.activities.isEmpty && dashboardResponse.activities.last?.checkOutTime == nil {
                isCheckedIn = true
            } else {
                isCheckedIn = false
            }
        }
    }
    
    private func fetchEmployeeType() -> Int {
        return UserDefaultManager.employeeType ?? -1
    }
}

#Preview {
    HomeView()
        .environmentObject(NavigationRouter())
}
