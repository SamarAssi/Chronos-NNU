//
//  SwipeToUnlockView.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct SwipeToUnlockView: View {
    @State var isReached: Bool = false
    @State var currentDragOffsetX: CGFloat = 0
    var width: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(setSwipeButtonColor())
                .frame(maxWidth: width)
                .frame(height: 60)

            Text(getSwipeButtonText())
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
            .offset(x: setSwipeButtonLimintation())
            .gesture(
                DragGesture()
                    .onChanged(
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            handleDragChanged
                        }
                    )
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            handleDragEnded()
                        }
                    }
            ), alignment: .leading
        )
    }
}

extension SwipeToUnlockView {
    func setSwipeButtonColor() -> LinearGradient {
        isReached ?
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

    func setSwipeButtonLimintation() -> CGFloat {
        return min(
            max(currentDragOffsetX, 0),
            UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60
        )
    }

    func getSwipeButtonText() -> String {
        isReached ? "Swipe to Check Out" : "Swipe to Check In"
    }

    func handleDragChanged(value: DragGesture.Value) {
        currentDragOffsetX = value.translation.width
    }

    func handleDragEnded() {
        if currentDragOffsetX >= UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60 {
            isReached.toggle()
        }

        currentDragOffsetX = 0
    }

    private func getRemainderOfHalfScreen() -> CGFloat {
        return UIScreen.main.bounds.size.width - width
    }
}

#Preview {
    SwipeToUnlockView(width: UIScreen.main.bounds.width)
}
