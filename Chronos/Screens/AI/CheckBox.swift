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
        HStack {
            Image(
                systemName: value ?
                "checkmark.square.fill" :
                "square"
            )
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(value ? .theme : .gray)

            Text(label)
            Spacer()
        }
        .padding(5)
        .onTapGesture {
            value.toggle()
        }
    }


}

#Preview(traits: .sizeThatFitsLayout) {
    CheckBox(value: .constant(true), label: "Select all employees")
}
