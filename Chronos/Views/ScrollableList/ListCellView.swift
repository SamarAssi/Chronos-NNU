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

    var backgroundColor: Color {
        isSelected ?
        Color.blackAndWhite.opacity(0.1) :
        Color.whiteAndBlack
    }
    
    var body: some View {
        listCellView
    }
}

extension ListCellView {
    var listCellView: some View {
        jobTitleView
            .frame(height: 45)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    var jobTitleView: some View {
        HStack {
            Text(name)
                .font(.system(size: 15, design: .rounded))
            
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    ListCellView(
        isSelected: .constant(false),
        name: "iOS"
    )
}
