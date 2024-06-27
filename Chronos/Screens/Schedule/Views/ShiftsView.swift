//
//  ShiftsView.swift
//  Chronos
//
//  Created by Samar Assi on 27/06/2024.
//

import SwiftUI

struct ShiftsView: View {
    
    @StateObject private var viewModel = ScheduleViewModel()
    
    @State private var selectedShift: ShiftRowUI?
    @State private var showEmployeesNamesList = false
    @State private var showCreateEventView = false
    @State private var showAIFeature = false
    @State private var buttonAnimation = false
    @State private var selectedEmployee: (String?, String?)
    @State private var filteredShifts: [ShiftRowUI] = []
    
    let hourWidth = 100.0
    var currentDate: Date = Date()
    
    var shifts: [ShiftRowUI] {
        fetchEmployeeType() == 1 ?
        filteredShifts :
        viewModel.newShifts
    }
    
    var body: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            HStack {
                dateView
                
                if fetchEmployeeType() == 1 {
                    Spacer()
                    aiButton
                }
            }
            
            if viewModel.isLoading {
                CustomProgressView()
            } else {
                if fetchEmployeeType() == 1 {
                    selectButtonView
                }
                scrollableCalendarView
            }
        }
        .safeAreaInset(edge: .bottom) {
            if fetchEmployeeType() == 1 {
                HStack {
                    Spacer()
                    FloatingActionButton
                }
            }
        }
        
        
        .fontDesign(.rounded)
        .onAppear {
            Task {
                await viewModel.getData()
            }
        }
        .sheet(item: $selectedShift) { shift in
            ShiftDetailsView(
                scheduleViewModel: viewModel,
                filteredShifts: $filteredShifts,
                shift: shift
            )
            .presentationDetents([.height(300), .large])
        }
        .sheet(isPresented: $showEmployeesNamesList) {
            EmployeeShiftListView(
                selectedEmployee: $selectedEmployee,
                shifts: filterShifts()
            )
            .presentationDetents([.height(300)])
        }
        .sheet(isPresented: $showCreateEventView) {
            CreateShiftView(
                selectedDate: $viewModel.selectedDate,
                filteredShifts: $filteredShifts
            )
        }
        .sheet(isPresented: $showAIFeature) {
            ShiftsSuggestionsView()
        }
        .onChange(of: selectedEmployee.0) { newValue, _ in
            filteredShifts.removeAll()
            
            for shift in viewModel.newShifts {
                if shift.employeeID == selectedEmployee.1 {
                    filteredShifts.append(shift)
                }
            }
        }
    }
}

extension ShiftsView {
    
    var selectButtonView: some View {
        Text(selectedEmployee.0 ?? "Select an employee")
            .font(.subheadline)
            .foregroundStyle(Color.white)
            .bold()
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black)
            )
            .padding(.horizontal)
            .padding(.bottom)
            .onTapGesture {
                showEmployeesNamesList.toggle()
            }
    }
    
    private var aiButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.5)) {
                withAnimation(.default) {
                    showAIFeature.toggle()
                }
            }
        }) {
            GifImageView("aiButton")
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 10)
                .scaleEffect(buttonAnimation ? 1.2 : 1.0)
                .animation(
                    .easeInOut(duration: 0.6)
                    .repeatForever(autoreverses: true)
                    .delay(0.2),
                    value: buttonAnimation
                )
                .onAppear {
                    buttonAnimation = true
                }
                .shadow(radius: 2)
                .padding()
        }
    }
    
    private var FloatingActionButton: some View {
        Button(action: {
            showCreateEventView.toggle()
        }) {
            Circle()
                .foregroundColor(.theme)
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(.white)
                        .padding(14)
                )
                .padding()
        }
    }
    
    var dateView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(currentDate.formatted(.dateTime.day().month()))
                    .bold()
                
                Text(currentDate.formatted(.dateTime.year()))
            }
            .font(.title)
            
            Text(currentDate.formatted(.dateTime.weekday(.wide)))
        }
        .padding()
    }
    
    var scrollableCalendarView: some View {
        ScrollView(.vertical) {
            ScrollView(.horizontal) {
                ZStack(alignment: .topLeading) {
                    VStack {
                        hoursView
                        
                    }
                    shiftsListView
                }
            }
        }
        .ignoresSafeArea()
    }
    
    var hoursView: some View {
        HStack(spacing: 0) {
            ForEach(0..<25) { hour in
                VStack {
                    Text(hour < 12 ? "AM" : "PM")
                        .font(.caption2)
                    Text("\(hour % 12 == 0 ? 12 : hour % 12)")
                        .font(.caption)
                        .padding(.vertical, 10)
                    
                    
                    Color.gray.opacity(0.5)
                        .frame(width: 1)
                        .frame(height: UIScreen.main.bounds.height)
                    
                }
                .frame(width: hourWidth)
            }
        }
    }
    
    var shiftsListView: some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            ForEach(shifts) { shift in
                shiftCell(shift: shift)
            }
            .padding(.leading, hourWidth / 2)
        }
    }
}

extension ShiftsView {
    
    private func filterShifts() -> [ShiftRowUI] {
        var uniqueShifts: [ShiftRowUI] = []
        
        for shift in viewModel.newShifts {
            if !uniqueShifts.contains(where: {
                $0.employeeID == shift.employeeID
            }) {
                uniqueShifts.append(shift)
            }
        }
        
        return uniqueShifts
    }
    
    private func shiftCell(shift: ShiftRowUI) -> some View {
        VStack(alignment: .leading) {
            Text(shift.employeeName)
            Text(shift.role)
            Text(formattedDate(shift.startTime))
            Text(formattedDate(shift.endTime))
        }
        .font(.caption)
        .frame(maxHeight: 80, alignment: .leading)
        .frame(
            width: max(
                0,
                calculateShiftWidth(
                    startTime: shift.startTime,
                    endTime: shift.endTime
                ) - 19
            ),
            alignment: .leading
        )
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(shift.backgroundColor.opacity(0.5))
        )
        .padding(.top, 66)
        .offset(x: calculateOffsetX(startTime: shift.startTime))
        .onTapGesture {
            selectedShift = shift
        }
    }
    
    private func calculateShiftWidth(startTime: Date, endTime: Date) -> CGFloat {
        let duration = endTime.timeIntervalSince(startTime)
        let width = CGFloat(duration / 3600) * hourWidth
        return width
    }
    
    private func calculateOffsetX(startTime: Date) -> Double {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: startTime)
        let minute = calendar.component(.minute, from: startTime)
        let offset = (Double(hour) + Double(minute) / 60) * hourWidth
        return offset
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func fetchEmployeeType() -> Int {
        return UserDefaultManager.employeeType ?? -1
    }
}

struct ShiftRowUI: Identifiable, Hashable {
    let id: String
    let employeeID: String
    let initials: String
    let employeeName: String
    let role: String
    let title: String
    let startTime: Date
    let endTime: Date
    let backgroundColor: Color
}

#Preview {
    ShiftsView()
}
