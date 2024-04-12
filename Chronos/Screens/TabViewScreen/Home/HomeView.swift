//
//  HomeView.swift
//  Chronos
//
//  Created by Samar Assi on 07/04/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            SwipeToUnlockView()
                .transition(AnyTransition.scale.animation(.spring(response: 0.3, dampingFraction: 0.5)))
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    HomeView()
}
