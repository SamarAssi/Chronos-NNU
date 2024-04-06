//
//  FieldContentView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct FieldContentView: View {
    var title: String
    
    @Binding var isFocused: Bool
    @Binding var content: String
    
    var body: some View {
        HStack {
            Text(title)
                .padding(.leading)
                .font(isFocusedAndFilled() ? .system(size: 14) : .system(size: 18))
                .offset(
                    x: isFocusedAndFilled() ? -1 : 0,
                    y: isFocusedAndFilled() ? -15 : 0
                )
                .foregroundStyle(
                    Color(Constant.CustomColor.DARK_TURQUOISE)
                        .opacity(0.8)
                )
                .animation(.linear(duration: 0.2), value: isFocusedAndFilled())
        }
    }
    
    func isFocusedAndFilled() -> Bool {
        return isFocused || !content.isEmpty
    }
}

#Preview {
    FieldContentView(
        title: "",
        isFocused: .constant(true),
        content: .constant("")
    )
}
