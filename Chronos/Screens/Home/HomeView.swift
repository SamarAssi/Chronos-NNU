//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.userList) { user in
                    Text("Name: \(user.name)")
                }
            }
        }
        .task {
            viewModel.getUsers(router: .home)
        }
    }
}

#Preview {
    HomeView()
}
