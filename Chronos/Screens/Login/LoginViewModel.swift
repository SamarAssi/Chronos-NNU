//
//  LoginViewModel.swift
//  Chronos
//
//  Created by Samar Assi on 15/04/2024.
//

import Foundation


final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
}
