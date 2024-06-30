//
//  OffEmployeeRowView.swift
//  Chronos
//
//  Created by Samar Assi on 30/06/2024.
//

import SwiftUI

struct OffEmployeeRowView: View {
    
    var rowModel: TimeOffRequestRowUIModel
    
    var formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: rowModel.startDate)
    }
    
    var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: rowModel.endDate)
    }
    
    var body: some View {
        contentView
    }
    
    var contentView: some View {
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .foregroundColor(rowModel.backgroundColor)
                    .frame(width: 45, height: 45)
                    .overlay(
                        Text(rowModel.initials)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(rowModel.username)
                        .font(.system(size: 18, weight: .bold))
                    HStack {
                        Text("\(formattedStartDate) to \(formattedEndDate)")
                            .font(.system(size: 13, design: .rounded))
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .frame(height: 50)
        .padding(16)
        .foregroundStyle(Color.primary)
        .background(Color.whiteAndBlack)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct TimeOffRequestRowUIModel: Identifiable {
    let id: String
    let initials: String
    let username: String
    let startDate: Date
    let endDate: Date
    let backgroundColor: Color
}


#Preview {
    OffEmployeeRowView(
        rowModel: TimeOffRequestRowUIModel(
            id: "",
            initials: "SA",
            username: "SamarAssi",
            startDate: Date(),
            endDate: Date(),
            backgroundColor: Color.green
        )
    )
}
