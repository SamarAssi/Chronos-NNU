//
//  CustomProgressView.swift
//  Chronos
//
//  Created by Samar Assi on 26/05/2024.
//

import SwiftUI

struct CustomProgressView: View {

    var body: some View {
        ProgressView()
            .progressViewStyle(
                CircularProgressViewStyle(tint: Color.theme)
            )
            .scaleEffect(1.5, anchor: .center)
            .offset(y: -10)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
            )
    }
}

#Preview {
    CustomProgressView()
}
