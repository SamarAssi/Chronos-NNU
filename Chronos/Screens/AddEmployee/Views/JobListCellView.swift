//
//  JobListCellView.swift
//  Chronos
//
//  Created by Samar Assi on 31/05/2024.
//

import SwiftUI

struct JobListCellView: View {
    @Binding var isSelectedJob: Bool
    var jobTitle: String
    
    var icon: String {
        isSelectedJob ?
        "checkmark" :
        ""
    }
    
    var backgroundColor: Color {
        isSelectedJob ?
        Color.silver.opacity(0.3) :
        Color.white
    }
    
    var body: some View {
        ZStack(
            alignment: .leading
        ) {
            listCellView
            jobTitleView
        }
    }
}

extension JobListCellView {
    var listCellView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
    }

    var jobTitleView: some View {
        HStack {
            Text(jobTitle)
                .font(.system(size: 15, design: .rounded))
            
            Image(systemName: icon)
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 30)
        .padding(.horizontal, 10)
    }
}

#Preview {
    JobListCellView(
        isSelectedJob: .constant(true),
        jobTitle: "iOS developer"
    )
}
