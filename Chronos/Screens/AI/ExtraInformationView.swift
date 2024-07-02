//
//  ExtraInformationView.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI

struct ExtraInformationView: View {

    @Binding var description: String
    let question: String

    var body: some View {
        List {
            Image(.textIcon)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 10)
                .listRowSeparator(.hidden)

            Text(question)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .listRowSeparator(.hidden)
                .padding(.bottom, 5)

            TextEditor(text: $description)
                .font(.system(size: 15))
                .textInputAutocapitalization(.never)
                .tint(Color.theme)
                .scrollContentBackground(.hidden)
                .padding(.vertical, 7)
                .padding(.horizontal, 10)
                .frame(height: 300)
                .background(Color.gray.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 0)
                .padding(.bottom, 10)
        }

    }
}

#Preview {
    ExtraInformationView(
        description: .constant(""),
        question: "Any extra information?"
    )
}
