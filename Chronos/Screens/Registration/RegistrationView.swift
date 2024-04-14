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

                    Text("Register")
                        .foregroundStyle(Color.theme)
                        .font(.system(size: 40, weight: .bold))
                        .padding(.bottom, 20)

                    TextFieldView(
                        text: $firstName,
                        label: "First Name",
                        placeholder: "Enter First Name",
                        isSecure: false
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $lastName,
                        label: "Last Name",
                        placeholder: "Enter Last Name",
                        isSecure: false
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $email,
                        label: "Email",
                        placeholder: "Enter Email Address",
                        isSecure: false
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $password,
                        label: "Password",
                        placeholder: "Enter Password",
                        isSecure: true
                    )
                    .padding(.bottom, 8)
                    
                    TextFieldView(
                        text: $confirmPassword,
                        label: "Confirm Password",
                        placeholder: "Confirm Password",
                        isSecure: true
                    )
                    .padding(.bottom, 30)
                    
                    MainButton(
                        buttonText: "Register",
                        action: {
                            //navigationRouter.navigateTo(.home)
                        }
                    )
                    
                    Spacer()
                    
                    FooterButton(
                        title: "Already have an account",
                        buttonText: "Login",
                        action: {
                            navigationRouter.navigateTo(.login)
                        }
                    )
                }
                .padding(20)
                .fontDesign(.rounded)
                .frame(minHeight: geometry.size.height)
            }
        }
    }
}

#Preview {
    RegistrationView()
        .environmentObject(NavigationRouter())
}
