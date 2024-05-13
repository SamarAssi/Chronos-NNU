//
//  NavigationLinkView.swift
//  Chronos
//
//  Created by Samar Assi on 05/05/2024.
//

import SwiftUI

struct NavigationLinkView<Destination: View>: View {
    var buttonText: LocalizedStringKey
    var backgroundColor: Color
    var destination: Destination

    var body: some View {
        NavigationLink(
            destination: destination
                .navigationBarBackButtonHidden(true)
        ) {
            Text(buttonText)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    NavigationLinkView(
        buttonText: "Next",
        backgroundColor: Color.theme,
        destination: Text("Destination View")
    )
}
