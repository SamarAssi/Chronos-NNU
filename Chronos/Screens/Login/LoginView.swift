//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            LogoView()
                .padding(.bottom, 10)
                .padding(.top, 10)
            
            TextFieldView(
                text: $email,
                label: "Email",
                fieldIcon: "envelope",
                placeholder: "Type your email",
                isSecure: false
            )
            .padding(.bottom, 8)
            
            
            TextFieldView(
                text: $password,
                label: "Password",
                fieldIcon: "lock",
                placeholder: "Type your password",
                isSecure: true
            )
            
            forgotPasswordButtonView
            loginButtonView
            
            Spacer()
            
            registrationButtonView
        }
        .padding(.horizontal, 20)
        .fontDesign(.rounded)
    }
}

extension LoginView {
    var forgotPasswordButtonView: some View {
        HStack {
            Spacer()
            MainButton(
                buttonText: "Forgot Password?",
                textButtonColor: Color.black.opacity(0.6),
                action: {
                    
                }
            )
        }
    }
    
    var loginButtonView: some View {
        MainButton(
            buttonText: "Login",
            textButtonColor: Color.white,
            action: {
                navigationRouter.navigateTo(.home)
            }
        )
        .fontWeight(.bold)
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(15)
        .padding(.top, 50)
    }
    
    var registrationButtonView: some View {
        HStack(spacing: 5) {
            Text(LocalizedStringKey("NoAccountQuestion"))
            MainButton(
                buttonText: "Register",
                textButtonColor: Color.darkTurquoise,
                action: {
                    
                }
            )
            .fontWeight(.bold)
        }
        .font(.system(size: 15))
    }
}

#Preview {
    LoginView()
        .environmentObject(NavigationRouter())
}
