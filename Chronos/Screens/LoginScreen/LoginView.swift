//
//  LoginView.swift
//  Chronos
//
//  Created by Samar Assi on 05/04/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: Router
    @State var email = ""
    @State var password = ""

    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            logoView
            emailFieldView
            passwordFieldView
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
    var logoView: some View {
        HStack(alignment: .bottom, spacing: 0) {
            Image("logo")
                .padding(.vertical, 20)
            Text(LocalizedStringKey(Constant.Key.APP_NAME))
                .font(.largeTitle)
                .padding(.bottom, 20)
                .foregroundStyle(Color.blue)
        }
        .padding(.bottom, 10)
        .padding(.top, 10)
    }
    
    var emailFieldView: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(Constant.Key.EMAIL_LABEL))
            TextFieldView(
                text: $email,
                isSecure: false,
                placeholder: "Type your email",
                fieldIcon: "envelope"
            )
        }
    }
    
    var passwordFieldView: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(Constant.Key.PASSWORD_LABEL))
            TextFieldView(
                text: $password,
                isSecure: true,
                placeholder: "Type your password",
                fieldIcon: "lock"
            )
        }
    }
    
    var forgotPasswordButtonView: some View {
        HStack {
            Spacer()
            MainButton(
                buttonText: "Forgot Password?",
                textButtonColor: Color.black.opacity(0.6),
                action: {
                    router.navigateTo(.passwordRecovery)
                }
            )
        }
    }
    
    var loginButtonView: some View {
        MainButton(
            buttonText: "Login",
            textButtonColor: Color.white,
            action: {
                router.navigateTo(.home)
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
            Spacer()
            Text(LocalizedStringKey(Constant.Key.NO_ACCOUNT_QUESTION))
            MainButton(
                buttonText: "Register",
                textButtonColor: Color(Constant.CustomColor.DARK_TURQUOISE),
                action: {
                    router.navigateTo(.registration)
                }
            )
            .fontWeight(.bold)
            Spacer()
        }
        .font(.system(size: 15))
    }
}

#Preview {
    LoginView()
        .environmentObject(Router())
}
