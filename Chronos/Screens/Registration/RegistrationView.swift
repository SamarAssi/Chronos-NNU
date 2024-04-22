//
//  RegistrationView.swift
//  Chronos
//
//  Created by Samar Assi on 09/04/2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var registrationViewModel = RegistrationViewModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(LocalizedStringKey("Register"))
                .foregroundStyle(Color.theme)
                .font(.system(size: 40, weight: .bold))
                .padding(.vertical, 30)
                .padding(.horizontal, 30)

            List(registrationViewModel.textFieldList.indices, id: \.self) { index in
                TextFieldView(
                    text: Binding<String>(
                        get: { registrationViewModel.textFieldList[index].text },
                        set: { newValue in
                            registrationViewModel.textFieldList[index].text = newValue
                        }
                    ),
                    label: registrationViewModel.textFieldList[index].label,
                    placeholder: registrationViewModel.textFieldList[index].placeholder,
                    isSecure: registrationViewModel.textFieldList[index].isSecure
                )
                .listRowSeparator(.hidden)
                .scrollIndicators(.hidden)
                .padding(.horizontal, 10)
            }
            .listStyle(PlainListStyle())

            MainButton(
                buttonText: LocalizedStringKey("Register"),
                action: {
                    // navigationRouter.navigateTo(.home)
                }
            )
            .padding(30)
        }
        .fontDesign(.rounded)

        Spacer()

        FooterButton(
            title: LocalizedStringKey("Already have an account?"),
            buttonText: LocalizedStringKey("Login"),
            action: {
                navigationRouter.navigateTo(.login)
            }
        )
        .padding(.bottom)
    }
}

#Preview {
    RegistrationView()
        .environmentObject(NavigationRouter())
}
