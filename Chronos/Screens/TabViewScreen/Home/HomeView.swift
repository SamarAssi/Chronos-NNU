//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate: Date = Date()
    
    let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
    let endDate = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
    
    var body: some View {
        VStack {
            headerSectionView
                .padding(.trailing, 30)
            
            HorizontalCalendarView(startDate: startDate, endDate: endDate)
            
            ScrollView {
                ZStack(alignment: .topLeading) {
                    Color("Silver").opacity(0.1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Today Attendance")
                            .fontWeight(.bold)
                            .padding(.bottom)

                        attendanceView
                        
                        HStack {
                            Text("Your Activity")
                                .fontWeight(.bold)
                            
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("View All")
                            }
                            .font(.system(size: 16))
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical)
                }
                .cornerRadius(30)
            }
            Spacer()
            
            SwipeToUnlockView()
                .transition(
                    AnyTransition.scale.animation(
                        .spring(
                            response: 0.3,
                            dampingFraction: 0.5
                        )
                    )
                )
                .padding(.horizontal, 20)
                
        }
        .padding(.bottom, 20)
        .fontDesign(.rounded)
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
                Text("Michael Mitc")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("Lead UI/UX Designer")
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
                .padding(.top, 10)
            
        }
    }
    
    var attendanceView: some View {
        HStack {
            AttendanceCardView(
                cardIcon: "tray.and.arrow.down",
                cardTitle: "Check In",
                time: "10:20 am",
                note: "On Time"
            )
            
            AttendanceCardView(
                cardIcon: "tray.and.arrow.up",
                cardTitle: "Check Out",
                time: "7:00 am",
                note: "Go Home"
            )
        }
    }
}

#Preview {
    HomeView()
}
