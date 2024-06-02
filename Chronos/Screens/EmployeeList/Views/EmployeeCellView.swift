//
//  EmployeeCellView.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import SwiftUI

struct EmployeeCellView: View {
    var fullName: String
    var jobs: [Job]

    var body: some View {
        ZStack(
            alignment: .leading
        ) {
            outerRoundedRectangleView
            roundedRhombusView
        }
    }
}

extension EmployeeCellView {
    var rowContentView: some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            Text(fullName)
                .font(.system(size: 20, weight: .bold))

            ForEach(
                jobs,
                id: \.self
            ) { job in
                Text(job.name)
                    .font(.system(size: 15))
                    .foregroundStyle(Color.gray)
            }
            .lineLimit(1)
            .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            .fill(Color.theme)
            .frame(width: 36, height: 100)
    }
}

#Preview {
    EmployeeCellView(
        fullName: "Samar Assi",
        jobs: [Job(id: "", name: "iOS developer")]
    )
}
