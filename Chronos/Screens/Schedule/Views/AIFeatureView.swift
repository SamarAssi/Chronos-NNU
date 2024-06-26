//
//  AIFeatureView.swift
//  Chronos
//
//  Created by Samar Assi on 24/06/2024.
//

import SwiftUI

struct AIFeatureView: View {

    @State var text = ""
    @State var isSubmitting = false

    var body: some View {
        contentView
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding()
    }


    private var contentView: some View {
        VStack {
            Text(LocalizedStringKey("AI Feature"))
                .font(.largeTitle)
                .padding()

            TextEditor(text: $text)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding()

            MainButton(
                isLoading: $isSubmitting,
                isEnable: .constant(true),
                buttonText: "Submit",
                backgroundColor: .theme) {
                }
        }
        .padding()
        .background(Color.black.opacity(0.1))
    }
}

#Preview {
    AIFeatureView()
}
