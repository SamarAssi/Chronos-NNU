//
//  SwipeToUnlockView.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct SwipeToUnlockView: View {
    @State private var currentDragOffsetX: CGFloat = 0
    @State private var isReached = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(setColor())
                .frame(maxWidth: .infinity)
                .frame(height: 60)
            
            Text(setText())
                .foregroundStyle(Color.white)
        }
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(setColor())
            }
            .padding(.leading, 5)
            .offset(x: min(max(currentDragOffsetX, 0), UIScreen.main.bounds.width - 101))
            .gesture(
                DragGesture()
                    .onChanged(handleDragChanged)
                    .onEnded { _ in
                        handleDragEnded()
                    }
            ), alignment: .leading
        )
    }
}

extension SwipeToUnlockView {
    private func setColor() -> LinearGradient {
        isReached ?
        LinearGradient(
            colors: [Color.red, Color.red.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        ) :
        LinearGradient(
            colors: [Color.blue, Color.blue.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }
    
    private func setText() -> String {
        isReached ? "Swipe to Check Out" : "Swipe to Check In"
    }
    
    private func handleDragChanged(value: DragGesture.Value) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentDragOffsetX = value.translation.width
        }
    }
    
    private func handleDragEnded() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            if currentDragOffsetX >= UIScreen.main.bounds.width - 101 {
                isReached.toggle()
            }
            
            currentDragOffsetX = 0
        }
    }
}

#Preview {
    SwipeToUnlockView()
}
