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
    
    @State private var selectedDestination: AnyView?
    
    var body: some View {
        NavigationStack {
            VStack(
                spacing: 0
            ) {
                profileHeaderView
                Divider()
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
            .padding(20)
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
    
    var accountOptionsListView: some View {
        List {
            Section {
                ForEach(
                    profileRowModel.indices,
                    id: \.self
                ) { index in
                    
                    Button(action: {
                        selectDestination(index: index)
                    }) {
                        profileRowLabel(
                            icon: profileRowModel[index].icon,
                            name: profileRowModel[index].name
                        )
                    }
                    .listRowBackground(Color.clear)
                }
                
                if fetchEmployeeType() == 1 {
                    jobsListButtonView
                    checkInOutSettingsButtonView
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
        .background(
            NavigationLink(
                destination: selectedDestination,
                isActive: Binding(
                    get: { selectedDestination != nil },
                    set: { if !$0 { selectedDestination = nil } }
                )
            ) {
                EmptyView()
            }
        )
    }
    
    var checkInOutSettingsButtonView: some View {
        Button(action: {
            selectedDestination = AnyView(
                SetupCheckInOutView()
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        isShowTabView = false
                    }
                    .onDisappear {
                        withAnimation {
                            isShowTabView = true
                        }
                    }
            )
        }) {
            profileRowLabel(
                icon: "location.fill",
                name: "Check In Out Settings"
            )
        }
        .listRowBackground(Color.clear)
    }
    
    var jobsListButtonView: some View {
        Button(action: {
            selectedDestination = AnyView(
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
            )
        }) {
            profileRowLabel(
                icon: "list.clipboard",
                name: "Jobs List"
            )
        }
        .listRowBackground(Color.clear)
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
            Button("Cancel", role: .cancel) {
                isShowAlert = false
            }
            Button("Log Out", role: .destructive) {
                UserDefaultManager.clear()
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
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray.opacity(0.5))
                .font(.system(size: 12))
                .fontWeight(.bold)
                .scaleEffect(1.1)
        }
    }

    private func selectDestination(index: Int) {
        switch index {
        case 0:
            selectedDestination = AnyView(
                EditProfileView()
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        isShowTabView = false
                    }
                    .onDisappear {
                        withAnimation {
                            isShowTabView = true
                        }
                    }
            )
        default:
            selectedDestination = AnyView(
                NewScreen(
                    item: profileRowModel[index].name
                )
            )
        }
    }
    
    private func fetchEmployeeType() -> Int {
        let employeeType = UserDefaultManager.employeeType ?? 0
        return employeeType
    }
    
    private func fetchFullName() -> String {
        return UserDefaultManager.fullName ?? ""
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
