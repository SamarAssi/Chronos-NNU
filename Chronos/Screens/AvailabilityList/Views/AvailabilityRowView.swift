//
//  AvailabilityRowView.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import SwiftUI

struct AvailabilityRowView: View {

    var rowModel: AvailabilityRowUIModel

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: rowModel.date)
    }

    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 80)
            .overlay {
                contentView
            }
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
                    Text(rowModel.name)
                        .font(.system(size: 18, weight: .bold))
                    HStack {
                        Text(formattedDate)
                            .font(.system(size: 14))

                        Spacer()

                        Text(LocalizedStringKey("Pending"))
                            .font(.system(size: 15))
                            .foregroundStyle(Color.theme)
                    }
                }
                .padding(.trailing, 22)
            }
            
            Divider()
                .padding(.vertical, 8)
        }
        .fontDesign(.rounded)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    AvailabilityRowView(
        rowModel: AvailabilityRowUIModel(
            initials: "SA",
            name: "Samar Assi",
            date: Date(),
            backgroundColor: Color.theme.opacity(0.5)
        )
    )
}
