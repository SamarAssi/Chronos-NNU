//
//  CheckBox.swift
//  Chronos
//
//  Created by Bassam Hillo on 28/06/2024.
//

import SwiftUI

struct CheckBox: View {

    @Binding var value: Bool
    let label: String

    var body: some View {
        HStack(spacing: 15) {
            Image(
                systemName: value ?
                "checkmark.square.fill" :
                "square"
            )
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(value ? .theme : .gray)

            Text(label)
                .font(.system(size: 14))
        }
        .padding(5)
        .padding(.bottom, 7)
        .onTapGesture {
            value.toggle()
        }
    }


}

#Preview(traits: .sizeThatFitsLayout) {
    CheckBox(value: .constant(true), label: "Select all employees")
}
