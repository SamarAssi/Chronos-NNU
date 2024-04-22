//
//  ProfileHeaderView.swift
//  Chronos
//
//  Created by Samar Assi on 20/04/2024.
//

import SwiftUI

struct ProfileHeaderView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Image("moon")
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 80)

            VStack(alignment: .leading, spacing: 3) {
                Text(LocalizedStringKey("Michael Mitc"))
                    .font(.title3)
                    .fontWeight(.bold)
                Text(LocalizedStringKey("Lead UI/UX Designer"))
                    .font(.system(size: 15))
            }

            Spacer()
            Image(systemName: "bell")
                .font(.title3)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .stroke()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                )
                .padding(.top, 12)
        }
    }
}

#Preview {
    ProfileHeaderView()
}
