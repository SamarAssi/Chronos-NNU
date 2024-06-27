//
//  ProfileHeaderView.swift
//  Chronos
//
//  Created by Samar Assi on 20/04/2024.
//

import SwiftUI

struct ProfileHeaderView: View {

    var body: some View {
        HStack(
            spacing: 5
        ) {
            profileImage
            userInfoView
            Spacer()
            notificationsBellView
        }
        .transition(
            .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        )
    }
}

extension ProfileHeaderView {

    var profileImage: some View {
        Image(.logo)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 60)
            .padding(.leading, 8)
    }

    var userInfoView: some View {
        VStack(
            alignment: .leading,
            spacing: 3
        ) {
            Text(fetchFullName())
                .font(.title3)
                .fontWeight(.bold)

            if fetchEmployeeType() == 1 {
                Text(LocalizedStringKey("Manager"))
                    .font(.system(size: 15))
            } else {
                Text(LocalizedStringKey("Employee"))
                    .font(.system(size: 15))
            }
        }
    }

    var notificationsBellView: some View {
        Image(systemName: "bell")
            .font(.title3)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .stroke()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
            )
            .padding(.bottom, 3)
    }
}

extension ProfileHeaderView {

    private func fetchEmployeeType() -> Int {
        return UserDefaultManager.employeeType ?? -1
    }

    private func fetchFullName() -> String {
        return UserDefaultManager.fullName ?? ""
    }
}

#Preview {
    ProfileHeaderView()
}
