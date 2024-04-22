//
//  SwipeToUnlockView.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct SwipeToUnlockView<SwipeButtonProvider: SwipeButton>: View {
    @ObservedObject var swipeButtonProvider: SwipeButtonProvider

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(setSwipeButtonColor())
                .frame(maxWidth: swipeButtonProvider.width)
                .frame(height: 60)

            Text(swipeButtonProvider.getSwipeButtonText())
                .foregroundStyle(Color.white)
        }
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 50, height: 50)

                Image(systemName: "arrow.right")
                    .foregroundStyle(setSwipeButtonColor())
            }
            .padding(.leading, 5)
            .offset(x: swipeButtonProvider.setSwipeButtonLimintation())
            .gesture(
                DragGesture()
                    .onChanged(
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            swipeButtonProvider.handleDragChanged
                        }
                    )
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            swipeButtonProvider.handleDragEnded()
                        }
                    }
            ), alignment: .leading
        )
        .onAppear {
            swipeButtonProvider.width = UIScreen.main.bounds.size.width
        }
    }

    func setSwipeButtonColor() -> LinearGradient {
        swipeButtonProvider.isReached ?
        LinearGradient(
            colors: [Color.red, Color.red.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        ) :
        LinearGradient(
            colors: [Color.theme, Color.theme.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    SwipeToUnlockView(swipeButtonProvider: ViewModel())
}
