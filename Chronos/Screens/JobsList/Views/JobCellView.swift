//
//  JobCellView.swift
//  Chronos
//
//  Created by Samar Assi on 09/06/2024.
//

import SwiftUI

struct JobCellView: View {

    @Binding var isSelected: Bool
    var isEditing: Bool
    var jobName: String
    
    var icon: String {
        isSelected ?
        "checkmark.circle" :
        "circle"
    }

    var body: some View {
        HStack {
            if !isEditing {
                Image(systemName: icon)
            }
            Rectangle()
                .fill(Color.white)
                .frame(height: 50)
                .overlay(alignment: .leading) {
                    Text(jobName)
                        .fontDesign(.rounded)
                }
        }
    }
}

#Preview {
    JobCellView(
        isSelected: .constant(false),
        isEditing: false,
        jobName: "iOS developer"
    )
}
