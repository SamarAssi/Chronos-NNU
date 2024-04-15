//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack(spacing: 10) {

            Image(.logo)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
                .padding(.horizontal, 20)

            TextFieldView(
                text: $email,
                label: "Email",
                placeholder: "Type your email",
                isSecure: false
            )
            .padding(.bottom, 8)

            TextFieldView(
                text: $password,
                label: "Password",
                placeholder: "Type your password",
                isSecure: true
            )

            forgotPasswordButtonView
            loginButtonView

            Spacer()

            FooterButton(
                title: "Didn't have an account?",
                buttonText: "Register",
                action: {
                    navigationRouter.navigateTo(.registration)
                }
            )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 30)
        .background(Color.white)
    }
}

extension LoginView {

    var forgotPasswordButtonView: some View {
        HStack {
            Spacer()
            Button {
                
            } label: {
                Text("Forgot Password?")
                    .foregroundStyle(Color.black.opacity(0.6))
                    .font(.subheadline)
            }
        }
    }
    
    var loginButtonView: some View {
        MainButton(
            buttonText: "Login",
            action: {
                navigationRouter.isLoggedIn = true
            }
        )
        .padding(.top, 50)
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
}
