//
//  ProfileView.swift
//  Chronos
//
//  Created by Samar Assi on 08/05/2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var profileRowModel: [ProfileRowModel] = ProfileRowModel.data
    @State private var isShowAlert = false

    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        NavigationStack {
            VStack(
                spacing: 25
            ) {
                profileHeaderView
                editButtonView
                    .padding(.horizontal, 30)
                accountOptionsListView
                Spacer()
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
            Image(.logo)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 130)

            VStack(
                alignment: .center,
                spacing: 8
            ) {
                Text(LocalizedStringKey("Michael Mitc"))
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)

                Text(LocalizedStringKey("Lead UI/UX Designer"))
                    .font(.system(size: 15))
                    .fontDesign(.rounded)
            }
            .padding(.horizontal, 30)
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
    }

    var accountOptionsListView: some View {
        List {
            Section {
                ForEach(profileRowModel) { row in
                    NavigationLink {
                        NewScreen(item: row.name)
                    } label: {
                        profileRowLabel(
                            icon: row.icon,
                            name: row.name
                        )
                    }
                    .padding(.vertical)
                }
            }

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
    ProfileView()
        .environmentObject(NavigationRouter())
}
