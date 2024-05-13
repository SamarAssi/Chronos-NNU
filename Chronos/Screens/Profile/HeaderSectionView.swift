//
//  HeaderSectionView.swift
//  Chronos
//
//  Created by Samar Assi on 08/05/2024.
//

import SwiftUI

struct HeaderSectionView: View {
    var name: LocalizedStringKey
    var role: LocalizedStringKey

    var body: some View {
        VStack(spacing: 20) {
            Image(.logo)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 130)

            VStack(alignment: .center, spacing: 8) {
                Text(name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)

                Text(role)
                    .font(.system(size: 15))
                    .fontDesign(.rounded)
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    HeaderSectionView(
        name: "Michael Mitc",
        role: "Lead UI/UX Designer"
    )
}
