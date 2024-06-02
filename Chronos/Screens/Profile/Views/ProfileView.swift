//
//  ProfileView.swift
//  Chronos
//
//  Created by Samar Assi on 08/05/2024.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var navigationRouter: NavigationRouter

    @State private var profileRowModel: [ProfileRowModel] = ProfileRowModel.data
    @State private var isShowAlert = false
    @Binding var isShowTabView: Bool

    var body: some View {
        NavigationStack {
            VStack(
                spacing: 25
            ) {
                profileHeaderView
                editButtonView
                accountOptionsListView
            }
        }
        .fontDesign(.rounded)
        .alert(
            LocalizedStringKey("Are you sure you want to log out?"),
            isPresented: $isShowAlert
        ) {
            alertButtonsView
        }
    }
}

extension ProfileView {

    var profileHeaderView: some View {
        VStack(
            spacing: 20
        ) {
            imageView

            VStack(
                alignment: .center,
                spacing: 8
            ) {
                userFullNameView
                userRoleView
            }
            .padding(.horizontal, 30)
        }
    }

    var imageView: some View {
        Image(.logo)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: 130)
    }

    var userFullNameView: some View {
        Text(fetchFullName())
            .font(.title3)
            .fontWeight(.bold)
            .fontDesign(.rounded)
    }

    var userRoleView: some View {
        Group {
            if fetchEmployeeType() == 1 {
                Text(LocalizedStringKey("Manager"))
                    .font(.system(size: 15))
                    .fontDesign(.rounded)
            } else {
                Text(LocalizedStringKey("Employee"))
                    .font(.system(size: 15))
                    .fontDesign(.rounded)
            }
        }
    }

    var editButtonView: some View {
        NavigationLink {
            EditProfileView()
                .navigationBarBackButtonHidden(true)
        } label: {
            Text(LocalizedStringKey("Edit"))
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color.theme)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .padding(.horizontal, 30)
    }

    var accountOptionsListView: some View {
        List {
            Section {
                ForEach(profileRowModel) { row in
                    NavigationLink {
                        NewScreen(item: row.name)
                            .onAppear {
                                isShowTabView = false
                            }
                            .onDisappear {
                                withAnimation {
                                    isShowTabView = true
                                }
                            }
                    } label: {
                        profileRowLabel(
                            icon: row.icon,
                            name: row.name
                        )
                    }
                }

                if fetchEmployeeType() == 1 {
                    NavigationLink {
                        JobsListView()
                            .navigationBarBackButtonHidden(true)
                            .onAppear {
                                isShowTabView = false
                            }
                            .onDisappear {
                                withAnimation {
                                    isShowTabView = true
                                }
                            }
                    } label: {
                        profileRowLabel(
                            icon: "list.clipboard",
                            name: LocalizedStringKey("Jobs List")
                        )
                    }
                }
            }
            .padding(.vertical)

            Section {
                logoutButtonView
            }
            .listRowSeparator(.hidden)
        }
        .scrollIndicators(.hidden)
        .listStyle(PlainListStyle())
        .padding(.horizontal, 10)
    }

    var logoutButtonView: some View {
        Button {
            isShowAlert.toggle()
        } label: {
            logoutButtonLabelView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
    }

    var logoutButtonLabelView: some View {
        HStack(
            spacing: 25
        ) {
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .background(
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 45, height: 45)
                )
            Text(LocalizedStringKey("Log out"))
        }
        .foregroundStyle(Color.red)
    }

    var alertButtonsView: some View {
        HStack {
            Button(LocalizedStringKey("Cancel"), role: .cancel) {
                isShowAlert = false
            }
            Button(LocalizedStringKey("Log Out"), role: .destructive) {
                _ = KeychainManager.shared.delete(
                    key: KeychainKeys.accessToken.rawValue
                )

                _ = KeychainManager.shared.delete(
                    key: KeychainKeys.employeeType.rawValue
                )

                _ = KeychainManager.shared.delete(
                    key: KeychainKeys.fullName.rawValue
                )
                navigationRouter.isLoggedIn = false
                navigationRouter.navigateTo(.login)
            }
        }
    }
}

extension ProfileView {

    private func profileRowLabel(
        icon: String,
        name: LocalizedStringKey
    ) -> some View {
        HStack(
            spacing: 25
        ) {
            Image(systemName: icon)
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 45, height: 45)
                )
            Text(name)
                .font(.system(size: 16))
        }
    }

    private func fetchEmployeeType() -> Int {
        if let employeeType = KeychainManager.shared.fetch(
            key: KeychainKeys.employeeType.rawValue
        ) {
            return Int(employeeType) ?? -1
        }

        return -1
    }

    private func fetchFullName() -> String {
        if let fullName = KeychainManager.shared.fetch(
            key: KeychainKeys.fullName.rawValue
        ) {
            return fullName
        }

        return ""
    }
}

struct NewScreen: View {
    var item: LocalizedStringKey
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(item)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "lessthan")
                    .scaleEffect(0.6)
                    .scaleEffect(x: 1, y: 2)
                    .onTapGesture {
                        dismiss.callAsFunction()
                    }
            }
        }
    }
}

#Preview {
    ProfileView(isShowTabView: .constant(false))
        .environmentObject(NavigationRouter())
}
