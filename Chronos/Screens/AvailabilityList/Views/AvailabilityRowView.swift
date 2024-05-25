//
//  AvailabilityRowView.swift
//  Chronos
//
//  Created by Samar Assi on 24/05/2024.
//

import SwiftUI

struct AvailabilityRowView: View {
    var date: Date
    var name: String
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd,yyyy"
        return formatter.string(from: date)
    }
    
    var body: some View {
        ZStack(
            alignment: .leading
        ) {
            outerRoundedRectangleView
            roundedRhombusView
        }
    }
}

extension AvailabilityRowView {
    var rowContentView: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                Text(formattedDate)
                    .font(.system(size: 15, weight: .bold))
                Spacer()
                Text(LocalizedStringKey("Pending"))
                    .font(.system(size: 15))
                    .foregroundStyle(Color.yellow)
            }
            
            Text(name)
                .font(.system(size: 20, weight: .bold))
        }
        .fontDesign(.rounded)
        .padding(.horizontal, 30)
    }
    
    var outerRoundedRectangleView: some View {
        RoundedRectangle(cornerRadius: 20.0)
            .fill(Color.white)
            .shadow(
                color: .gray.opacity(0.1),
                radius: 5,
                x: 0,
                y: 20
            )
            .frame(height: 100)
            .overlay(rowContentView)
    }
    
    var roundedRhombusView: some View {
        RoundedRhombus(cornerRadius: 20)
            .fill(Color.yellow)
            .frame(width: 36, height: 100)
    }
}

#Preview {
    AvailabilityRowView(date: Date(), name: "Samar Assi")
}
