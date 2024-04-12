//
//  RegistrationView.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 5) {
                    LogoView(title: "Register Account")
                        .padding(.bottom, 30)
                        .padding(.top, 10)
                    
                    TextFieldView(
                        text: $firstName,
                        label: "First Name",
                        fieldIcon: "person",
                        placeholder: "Enter First Name",
                        isSecure: false
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $lastName,
                        label: "Last Name",
                        fieldIcon: "person",
                        placeholder: "Enter Last Name",
                        isSecure: false
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $email,
                        label: "Email",
                        fieldIcon: "envelope",
                        placeholder: "Enter Email Address",
                        isSecure: false
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $password,
                        label: "Password",
                        fieldIcon: "lock",
                        placeholder: "Enter Password",
                        isSecure: true
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $confirmPassword,
                        label: "Confirm Password",
                        fieldIcon: "lock",
                        placeholder: "Confirm Password",
                        isSecure: true
                    )
                    .padding(.bottom, 30)
                    
                    registrationButtonView
                    
                    Spacer()
                    
                    FooterButton(
                        title: "Already have an account",
                        buttonText: "Login",
                        action: {
                            navigationRouter.navigateTo(.login)
                        }
                    )
                }
                .padding(.horizontal, 20)
                .fontDesign(.rounded)
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

extension RegistrationView {
    var registrationButtonView: some View {
        MainButton(
            buttonText: "Register",
            textButtonColor: Color.white,
            action: {
                //navigationRouter.navigateTo(.home)
            }
        )
        .fontWeight(.bold)
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(Color.blue)
        .cornerRadius(15)
    }
}

#Preview {
    RegistrationView()
        .environmentObject(NavigationRouter())
}
