//
//  ActivityIndicatorView.swift
//  Chronos
//
//  Created by Samar Assi on 29/04/2024.
//

import Foundation
import SwiftUI
import NVActivityIndicatorView

struct ActivityIndicatorView: UIViewRepresentable {
    let type: NVActivityIndicatorType
    let color: UIColor

    func makeUIView(context: Context) -> NVActivityIndicatorView {
        let activityIndicatorView = NVActivityIndicatorView(
            frame: .zero,
            type: type,
            color: color,
            padding: 25
        )
        return activityIndicatorView
    }

    func updateUIView(_ uiView: NVActivityIndicatorView, context: Context) {
        uiView.type = type
        uiView.color = color
        uiView.startAnimating()
    }
}
