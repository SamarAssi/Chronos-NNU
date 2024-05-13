//
//  ProfileView.swift
//  Chronos
//
//  Created by Samar Assi on 08/05/2024.
//

import SwiftUI

struct ProfileView: View {
    @State private var listItems: [ListItemModel] = []
    @State private var isShowAlert = false
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                HeaderSectionView(
                    name: LocalizedStringKey("Michael Mitc"),
                    role: LocalizedStringKey("Lead UI/UX Designer")
                )

                NavigationLinkView(
                    buttonText: LocalizedStringKey("Edit"),
                    backgroundColor: Color.theme,
                    destination: EditProfileView()
                )
                .padding(.horizontal, 30)

//                accountOptionsListView
                accountOptionsScrollView

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
        .onAppear {
            setListItems()
        }
    }
}

extension ProfileView {
    var accountOptionsListView: some View {
        List {
            Section {
                ForEach(listItems) { listItem in
                    NavigationLink {
                        NewScreen(item: listItem.name)
                    } label: {
                        HStack(spacing: 25) {
                            Image(systemName: listItem.icon)
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 45, height: 45)
                                )
                            Text(listItem.name)
                                .font(.system(size: 16))
                        }
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

    var accountOptionsScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(listItems) { listItem in
                    NavigationLink {
                        NewScreen(item: listItem.name)
                    } label: {
                        setItemLabel(icon: listItem.icon, name: listItem.name)
                    }
                    .padding(.vertical)

                    Divider()
                        .padding(.horizontal, 30)
                }

                logoutButtonView
                    .padding(.horizontal, 30)
            }
        }
        .scrollIndicators(.hidden)
    }

    var logoutButtonView: some View {
        Button(action: {
            isShowAlert.toggle()
        }, label: {
            HStack(spacing: 25) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .background(
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 45, height: 45)
                    )
                Text(LocalizedStringKey("Log out"))
            }
            .foregroundStyle(Color.red)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical)
    }

    var alertButtonsView: some View {
        HStack {
            Button("Cancel", role: .cancel) {
                isShowAlert = false
            }
            Button("Log Out", role: .destructive) {
                _ = KeychainManager.shared.delete(
                    key: KeychainKeys.accessToken.rawValue
                )
                navigationRouter.isLoggedIn = false
            }
        }
    }
}

extension ProfileView {
    private func setItemLabel(icon: String, name: LocalizedStringKey) -> some View {
        HStack(spacing: 25) {
            Image(systemName: icon)
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 45, height: 45)
                )
            Text(name)
                .font(.system(size: 16))

            Spacer()

            Image(systemName: "greaterthan")
                .foregroundStyle(Color.gray.opacity(0.5))
                .scaleEffect(0.6)
                .scaleEffect(x: 1, y: 2)
        }
        .foregroundStyle(Color.black)
        .padding(.horizontal, 30)
    }

    private func setListItems() {
        listItems = [
            ListItemModel(
                name: LocalizedStringKey("My Profile"),
                icon: "person"
            ),
            ListItemModel(
                name: LocalizedStringKey("Settings"),
                icon: "gearshape"
            ),
            ListItemModel(
                name: LocalizedStringKey("Teams & Conditions"),
                icon: "list.bullet.rectangle"
            ),
            ListItemModel(
                name: LocalizedStringKey("Privacy Policy"),
                icon: "checkmark.shield"
            )
        ]
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
