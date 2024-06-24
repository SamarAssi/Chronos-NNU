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
        VStack(spacing: 0) {
            HStack {
                Circle()
                    .foregroundColor(rowModel.backgroundColor)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(rowModel.initials)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(rowModel.name)
                        .font(.system(size: 20, weight: .bold))
                    HStack {
                        Text(formattedDate)
                            .font(.system(size: 15))

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
