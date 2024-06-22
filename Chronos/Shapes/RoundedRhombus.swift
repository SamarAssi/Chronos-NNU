//
//  RoundedRhombus.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import Foundation
import SwiftUI

struct RoundedRhombus: Shape {

    let cornerRadius: Double

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))

            path.addQuadCurve(
                to: CGPoint(
                    x: rect.minX + cornerRadius,
                    y: rect.minY
                ),
                control: CGPoint(
                    x: rect.minX,
                    y: rect.minY
                )
            )

            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))

            path.addQuadCurve(
                to: CGPoint(
                    x: rect.minX,
                    y: rect.maxY - cornerRadius
                ),
                control: CGPoint(
                    x: rect.minX,
                    y: rect.maxY
                )
            )
        }
    }
}
