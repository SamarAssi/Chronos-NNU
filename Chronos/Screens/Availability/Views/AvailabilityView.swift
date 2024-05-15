//
//  AvailabilityView.swift
//  Chronos
//
//  Created by Samar Assi on 15/05/2024.
//

import SwiftUI

struct AvailabilityView: View {
    
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            titleView
                .padding(.horizontal)
            horizontalDividerView
        }
        .fontDesign(.rounded)
    }
}

extension AvailabilityView {
    var titleView: some View {
        Text(LocalizedStringKey("Availability"))
            .font(.title2)
            .fontWeight(.bold)
    }
    
    var horizontalDividerView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.5))
            .frame(height: 3)
    }
}

#Preview {
    AvailabilityView()
}
