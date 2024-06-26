//
//  SwipeToUnlockView.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct SwipeToUnlockView: View {
    @State private var isCheckedIn: Bool = false
    @State private var currentDragOffsetX: CGFloat = 0
    @Binding var selectedDate: Date?
    var width: CGFloat

    var isDisabledSwipeButton: Bool {
        if let selectedDate = selectedDate {
            return selectedDate < Date()
        }

        return false
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(swipeButtonColor)
                .frame(maxWidth: width)
                .frame(height: 60)

            Text(getSwipeButtonText())
                .foregroundStyle(Color.white)
        }
        .overlay(overlayContentView, alignment: .leading)
        .transition(
            AnyTransition.scale.animation(
                .spring(
                    response: 0.3,
                    dampingFraction: 0.5
                )
            )
        )
        .disabled(isDisabledSwipeButton)
    }
}

extension SwipeToUnlockView {
    var overlayContentView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .frame(width: 50, height: 50)

            Image(systemName: "arrow.right")
                .foregroundStyle(swipeButtonColor)
        }
        .padding(.leading, 5)
        .offset(x: setSwipeButtonLimintation())
        .gesture(
            DragGesture()
                .onChanged(handleDragChanged)
                .onEnded { _ in
                        handleDragEnded()
                }
        )
    }

    var swipeButtonColor: LinearGradient {
        if let selectedDate = selectedDate {
            if selectedDate < Date() {
                return LinearGradient(
                    colors: [Color.theme.opacity(0.5)],
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
            }
        }

        if isCheckedIn {
            return LinearGradient(
                colors: [Color.red, Color.red.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [Color.theme, Color.theme.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottomTrailing
            )
        }
    }
}

extension SwipeToUnlockView {
    private func setSwipeButtonLimintation() -> CGFloat {
        return min(
            max(currentDragOffsetX, 0),
            UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60
        )
    }

    private func getSwipeButtonText() -> String {
        isCheckedIn ?
        "Swipe to Check Out" :
        "Swipe to Check In"
    }

    private func handleDragChanged(value: DragGesture.Value) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentDragOffsetX = value.translation.width
        }
    }

    private func handleDragEnded() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if currentDragOffsetX >= UIScreen.main.bounds.width - getRemainderOfHalfScreen() - 60 {
                isCheckedIn.toggle()
                handleCheckInOutResponse()
            }

            currentDragOffsetX = 0
        }
    }

    private func getRemainderOfHalfScreen() -> CGFloat {
        return UIScreen.main.bounds.size.width - width
    }

    private func performCheckInOutRequest() async throws -> CheckInOutResponse {
        return try await AuthenticationClient.updateCheckInOut()
    }

    private func handleCheckInOutResponse() {
        Task {
            let response = try await performCheckInOutRequest()
            if response.checkInStatus == 1 {
                isCheckedIn = true
            } else {
                isCheckedIn = false
            }
        }
    }
}

#Preview {
    SwipeToUnlockView(selectedDate: .constant(nil), width: UIScreen.main.bounds.width)
}
