//
//  SwipeButton.swift
//  Chronos
//
//  Created by Samar Assi on 20/04/2024.
//

import Foundation
import SwiftUI

protocol SwipeButton: ObservableObject {
    var currentDragOffsetX: CGFloat { get set }
    var isReached: Bool { get set }

    func getSwipeButtonText() -> String
    func setSwipeButtonLimintation() -> CGFloat
    func handleDragChanged(value: DragGesture.Value)
    func handleDragEnded()
}
