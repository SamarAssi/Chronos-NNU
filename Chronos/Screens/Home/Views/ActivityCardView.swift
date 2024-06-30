//
//  ActivityCardView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct ActivityCardView: View {
    
    var icon: String
    var title: LocalizedStringKey
    var date: Date
    var iconColor: Color
    var employeeName: String
    
    var height: CGFloat {
        fetchEmployeeType() == 1 ?
        80 :
        50
    }
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            if fetchEmployeeType() == 1 {
                employeeNameView
            }
            
            HStack(
                spacing: 10
            ) {
                iconView
                firstColumnView
                Spacer()
                secondColumnView
            }
        }
        .fontDesign(.rounded)
        .frame(height: height)
        .padding(16)
        .foregroundStyle(Color.primary)
        .background(Color.whiteAndBlack)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension ActivityCardView {
    
    var firstColumnView: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            titleView
            dateView
        }
    }
    
    var secondColumnView: some View {
        VStack(
            alignment: .leading,
            spacing: 5
        ) {
            timeView
            labelView
        }
    }
    
    var employeeNameView: some View {
        Text(employeeName)
            .font(.system(size: 16))
            .fontWeight(.bold)
    }
    
    var iconView: some View {
        Image(systemName: icon)
            .foregroundStyle(iconColor)
            .frame(width: 45, height: 45)
            .background(iconColor.opacity(0.1))
            .cornerRadius(10)
    }
    
    var titleView: some View {
        Text(title)
            .font(
                .system(
                    size: 16,
                    weight: .bold,
                    design: .rounded
                )
            )
    }
    
    var dateView: some View {
        Text(date.toString(format: "MMMM dd,yyyy"))
            .font(.system(size: 13, design: .rounded))
            .foregroundStyle(Color.gray)
    }
    
    var timeView: some View {
        Text(date.toString(format: "hh:mm a"))
            .font(
                .system(
                    size: 16,
                    weight: .bold,
                    design: .rounded
                )
            )
    }
    
    var labelView: some View {
        Text(LocalizedStringKey("On Time"))
            .font(.system(size: 13, design: .rounded))
            .foregroundStyle(Color.gray)
    }
    
    private func fetchEmployeeType() -> Int {
        return UserDefaultManager.employeeType ?? -1
    }
}

#Preview {
    ActivityCardView(
        icon: "tray.and.arrow.down",
        title: "Check In",
        date: Date(),
        iconColor: Color.theme,
        employeeName: "Samar"
    )
}
