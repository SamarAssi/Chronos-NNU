//
//  LogoView.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("logo")
                .padding(.vertical, 20)
            Text(LocalizedStringKey("AppName"))
                .font(.largeTitle)
                .padding(.bottom, 20)
                .foregroundStyle(Color.blue)
        }
    }
}

#Preview {
    LogoView()
}
