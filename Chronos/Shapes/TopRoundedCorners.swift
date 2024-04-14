//
//  TopRoundedCorners.swift
//  Chronos
//
//  Created by Bassam Hillo on 14/04/2024.
//

import SwiftUI

struct TopRoundedCorners: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        path.move(to: CGPoint(x: topLeft.x + radius, y: topLeft.y))
        path.addArc(center: CGPoint(x: topLeft.x + radius, y: topLeft.y + radius), radius: radius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        path.addLine(to: CGPoint(x: topRight.x - radius, y: topRight.y))
        path.addArc(center: CGPoint(x: topRight.x - radius, y: topRight.y + radius), radius: radius, startAngle: .degrees(270), endAngle: .degrees(360), clockwise: false)
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y))
        path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y))
        path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + radius))

        return path
    }
}
