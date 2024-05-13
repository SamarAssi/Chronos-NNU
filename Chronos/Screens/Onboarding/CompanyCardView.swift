//
//  CompanyCardView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct CompanyCardView: View {
    var name: LocalizedStringKey
    var description: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(name)
                .font(.system(size: 20, weight: .bold, design: .rounded))

            Text(description)
                .fontDesign(.rounded)
                .foregroundStyle(Color.gray)
        }
        .padding()
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.theme)
        )
    }
}

#Preview {
    CompanyCardView(
        name: "Foothill Technology Solutions",
        description: "This is a programming company created in 2014."
    )
}
