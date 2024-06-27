//
//  ShiftDetailsView.swift
//  Chronos
//
//  Created by Samar Assi on 27/06/2024.
//

import SwiftUI

struct ShiftDetailsView: View {

    @Environment(\.dismiss) var dismiss
    @ObservedObject var scheduleViewModel: ScheduleViewModel
    
    @Binding var filteredShifts: [ShiftRowUI]

    var shift: ShiftRowUI
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(
                alignment: .top,
                spacing: 15
            ) {
                initialLabel
                employeeNameAndRoleView
                
                Spacer()
                
                Text(LocalizedStringKey("Delete"))
                    .font(.subheadline)
                    .foregroundStyle(Color.red)
                    .bold()
                    .onTapGesture {
                        scheduleViewModel.handleShiftDeletion(id: shift.id)
                        for filteredShift in filteredShifts {
                            if filteredShift.id == shift.id {
                                if let index = filteredShifts.firstIndex(of: filteredShift) {
                                    filteredShifts.remove(at: index)
                                }
                            }
                        }
                        dismiss.callAsFunction()
                    }
                    .padding(.top, 2)
                    .padding(.trailing, 15)
            }
            .padding(.vertical, 30)
            
            Divider()
    
            timesView
            
            Divider()
            
            jobDescriptionView
            
            Spacer()
        }
    }
}

extension ShiftDetailsView {

    var initialLabel: some View {
        Circle()
            .foregroundColor(shift.backgroundColor)
            .frame(width: 55, height: 55)
            .overlay(
                Text(shift.initials)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            )
            .padding(.leading, 15)
    }
    
    var employeeNameAndRoleView: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            Text(shift.employeeName)
                .font(.title2)
                .bold()

            Text(shift.role)
                .font(.subheadline)
                .foregroundStyle(Color.gray)
        }
    }
    
    var timesView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Start Time: "))
                .bold() +
            Text(formattedDate(shift.startTime))
                .foregroundStyle(Color.gray)
                .font(.subheadline)
            
            Text(LocalizedStringKey("End Time: "))
                .bold() +
            Text(formattedDate(shift.endTime))
                .foregroundStyle(Color.gray)
                .font(.subheadline)
        }
        .padding()
    }
    
    var jobDescriptionView: some View {
        VStack(
            alignment: .leading
        ) {
            Text(LocalizedStringKey("Job Description: "))
                .bold()
            Text(shift.title)
                .font(.subheadline)
                .foregroundStyle(Color.gray)
        }
        .padding()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ShiftDetailsView(
        scheduleViewModel: ScheduleViewModel(),
        filteredShifts: .constant([]),
        shift: ShiftRowUI(
            id: "1",
            employeeID: "2",
            initials: "SA",
            employeeName: "Samar Assi",
            role: "iOS",
            title: "iOS Developer",
            startTime: Date(),
            endTime: Date(),
            backgroundColor: Color.green
        )
    )
}
