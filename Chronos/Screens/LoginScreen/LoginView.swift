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
    @State var isTappedPassword = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            logoView
            headerView
            emailFieldView
            passwordFieldView
            forgotPasswordButtonView
            loginButtonView
            
            Spacer()
                .frame(maxHeight: .infinity)
            
            registrationButtonView
        }
        .padding(.horizontal, 20)
        .fontDesign(.rounded)
    }
}

extension LoginView {
    var logoView: some View {
        Image("logo")
            .padding(.vertical, 20)
    }
    
    var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                Text("Welcome Back 👋")
                    .font(.title)
                Text("to")
                    .font(.title) +
                Text(" CHRONOS")
                    .font(.largeTitle)
                    .foregroundStyle(Color.blue)
            }
            .fontWeight(.bold)
            
            Text("Hello there, login to continue")
                .foregroundStyle(Color.gray)
                .font(.callout)
        }
        .padding(.bottom)
    }
    
    var emailFieldView: some View {
        TextFieldView(
            text: $email,
            title: "Email Address"
        )
    }
    
    var passwordFieldView: some View {
        SecureFieldView(
            password: $password,
            title: "Password"
        )
    }
    
    var forgotPasswordButtonView: some View {
        HStack {
            Spacer()
            ButtonView(
                buttonText: "Forgot Password ?",
                textButtonColor: Color(Constant.CustomColor.DARK_TURQUOISE),
                action: {
                    
                }
            )
        }
    }
    
    var loginButtonView: some View {
        ButtonView(
            buttonText: "Login",
            textButtonColor: Color.white,
            action: {
                
            }
        )
        .frame(height: 65)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(15)
        .padding(.top)
    }
    
    var registrationButtonView: some View {
        HStack {
            Spacer()
            Text("Didn't have an account?")
            ButtonView(
                buttonText: "Register",
                textButtonColor: Color(Constant.CustomColor.DARK_TURQUOISE),
                action: {
                    
                }
            )
            Spacer()
        }
        .font(.system(size: 15))
    }
}

#Preview {
    LoginView()
}
