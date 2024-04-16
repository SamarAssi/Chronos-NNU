//
//  AttendanceCardView.swift
//  Chronos
//
//  Created by Samar Assi on 13/04/2024.
//

import SwiftUI

struct AttendanceCardView: View {
    var cardIcon: String
    var cardTitle: LocalizedStringKey
    var time: LocalizedStringKey
    var note: LocalizedStringKey
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 15) {
                Image(systemName: cardIcon)
                    .foregroundStyle(Color.theme)
                    .frame(width: 40, height: 40)
                    .background(Color.theme.opacity(0.1))
                    .cornerRadius(10)
                
                Text(cardTitle)
            }
            .padding(.bottom)
            
            Text(time)
                .font(.title3)
                .fontWeight(.bold)
            Text(note)
                .font(.subheadline)
        }
        .frame(width: 172, height: 150)
        .background(Color.white)
        .cornerRadius(25)
    }
}

#Preview {
    AttendanceCardView(
        cardIcon: "tray.and.arrow.down",
        cardTitle: "Check In",
        time: "10:20 am",
        note: "On Time"
    )
}
