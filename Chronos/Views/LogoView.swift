//
//  LogoView.swift
//  Chronos
//
//  Created by Samar Assi on 08/04/2024.
//

import SwiftUI

struct LogoView: View {
    var title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 70)
                .padding(.bottom)
            
            Group {
                Text(title)
                    .font(.system(size: 22))
                Text("to ")
                    .font(.system(size: 22)) +
                Text("Chronos")
                    .font(.system(size: 25))
                    .foregroundStyle(Color.blue)
            }
            .fontWeight(.bold)
        }
    }
}

#Preview {
    LogoView(
        title: "Welcome Back"
    )
}
