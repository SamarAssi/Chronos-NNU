//
//  ShiftRowView.swift
//  Chronos
//
//  Created by Bassam Hillo on 25/06/2024.
//

import SwiftUI

struct ShiftRowView: View {

    @ObservedObject var scheduleViewModel = ScheduleViewModel()
    var model: ShiftRowUIModel

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .foregroundColor(model.backgroundColor)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(model.initials)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                )
                .padding(.leading, 15)

            VStack(alignment: .leading, spacing: 5) {
                Text(model.title)
                    .font(.system(size: 15, weight: .semibold))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .lineLimit(1)

                HStack(spacing: 2) {
                    Text("Start:")
                        .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.black)
                    Text("\(model.startTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }

                HStack(spacing: 2) {
                    Text("End: ")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.black)
                    Text("\(model.endTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                }
            }
            .padding(10)

            Spacer()

            if model.isNew {
                Text("New")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.green.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
            }
        }
        .background(model.backgroundColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(alignment: .topTrailing) {
            cancelButtonView
                .padding(.top, 12)
                .padding(.trailing, 15)
        }
    }
    
    var cancelButtonView: some View {
        Image(systemName: "xmark")
            .scaleEffect(0.8)
            .onTapGesture {
                scheduleViewModel.handleShiftDeletion(id: model.id)
            }
    }
}

#Preview {
    ShiftRowView(
        model: ShiftRowUIModel(
            id: "1",
            employeeID: "2",
            initials: "MS",
            employeeName: "",
            role: "",
            title: "Morning Shift",
            startTime: "8:00 AM",
            endTime: "12:00 PM",
            backgroundColor: .theme,
            isNew: true
        )
    )
}
