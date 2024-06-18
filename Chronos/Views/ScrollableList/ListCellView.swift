//
//  ListCellView.swift
//  Chronos
//
//  Created by Samar Assi on 17/06/2024.
//

import SwiftUI

struct ListCellView: View {

    @Binding var isSelected: Bool
    var name: String
    
    var icon: String {
        isSelected ?
        "checkmark.circle" :
        "circle"
    }
    
    var backgroundColor: Color {
        isSelected ?
        Color.silver.opacity(0.3) :
        Color.white
    }
    
    var body: some View {
        listCellView
    }
}

extension ListCellView {
    var listCellView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
            .frame(height: 45)
            .overlay {
                jobTitleView
            }
    }

    var jobTitleView: some View {
        HStack {
            Text(name)
                .font(.system(size: 15, design: .rounded))
            
            Image(systemName: icon)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
//        .frame(height: 30)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ListCellView(
        isSelected: .constant(false),
        name: "iOS"
    )
}
