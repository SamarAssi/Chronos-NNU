//
//  SwipeToUnlockView.swift
//  Chronos
//
//  Created by Samar Assi on 10/04/2024.
//

import SwiftUI

struct SwipeToUnlockView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(mainViewModel.setColor())
                .frame(maxWidth: .infinity)
                .frame(height: 60)
            
            Text(mainViewModel.setText())
                .foregroundStyle(Color.white)
        }
        .overlay(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "arrow.right")
                    .foregroundStyle(mainViewModel.setColor())
            }
            .padding(.leading, 5)
            .offset(x: mainViewModel.setSwipeLimitation())
            .gesture(
                DragGesture()
                    .onChanged(mainViewModel.handleDragChanged)
                    .onEnded { _ in
                        mainViewModel.handleDragEnded()
                    }
            ), alignment: .leading
        )
    }
}

#Preview {
    SwipeToUnlockView(mainViewModel: MainViewModel())
}
