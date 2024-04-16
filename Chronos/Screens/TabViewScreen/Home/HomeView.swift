//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var mainViewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 0) {
            headerSectionView
                .padding(.trailing, 30)
                .padding(.top)

            
            if mainViewModel.isShow {
                horizontalCalenderView
            }
            
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        attendanceView
                        activityView
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 20)

                    .background(mainViewModel.scrollBackground())
                }
                .scrollIndicators(.hidden)
                
                SwipeToUnlockView(mainViewModel: mainViewModel)
                    .transition(
                        AnyTransition.scale.animation(
                            .spring(
                                response: 0.3,
                                dampingFraction: 0.5
                            )
                        )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .fontDesign(.rounded)
        .animation(.easeInOut, value: mainViewModel.isShow)
    }
}

extension HomeView {
    var headerSectionView: some View {
        HStack(alignment: .top) {
            Image("moon")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 80)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(LocalizedStringKey("Michael Mitc"))
                    .font(.title3)
                    .fontWeight(.bold)
                Text(LocalizedStringKey("Lead UI/UX Designer"))
                    .font(.system(size: 15))
            }
            
            Spacer()
            Image(systemName: "bell")
                .font(.title3)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                )
                .padding(.top, 12)
        }
    }
    
    var horizontalCalenderView: some View {
        HorizontalCalendarView(
            mainViewModel: mainViewModel,
            startDate: mainViewModel.startDate,
            endDate: mainViewModel.endDate
        )
        .padding(.top, 30)
        .transition(
            .asymmetric(
                insertion: .push(from: .top),
                removal: .push(from: .bottom)
            )
        )
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
                .shadow(radius: 2)
                
                AttendanceCardView(
                    cardIcon: "tray.and.arrow.up",
                    cardTitle: LocalizedStringKey("Check Out"),
                    time: LocalizedStringKey("7:00 am"),
                    note: LocalizedStringKey("Go Home")
                )
                .shadow(radius: 2)
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
                .foregroundStyle(Color.theme)
            }
            .padding(.top, 20)
            .padding(.bottom)
            
            if mainViewModel.activities.isEmpty {
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
